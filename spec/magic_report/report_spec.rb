# frozen_string_literal: true

RSpec.describe MagicReport::Report do
  let(:subject) { report.new }

  let(:user) do
    OpenStruct.new(
      id: 5,
      name: "Dan",
      surname: "Magic",
      address: OpenStruct.new(address_line_1: "Ave street", city: "NY"),
      cars: [OpenStruct.new(name: "BMW"), OpenStruct.new(name: "Lexus")]
    )
  end

  context "when report with only `fields` is provided" do
    let(:report) do
      Class.new(MagicReport::Report) do
        fields :id, :name
        field :full_name, ->(user) { user.name + user.surname }

        class << self
          def name
            "User"
          end
        end
      end
    end

    it "works correctly" do
      row = subject.process(user)

      expect(row.to_h).to eq(id: 5, name: "Dan", full_name: "DanMagic")
    end
  end

  context "when report with nested `has_one` is provided" do
    let(:report) do
      Class.new(MagicReport::Report) do
        class Address < MagicReport::Report
          field :address_line_1
          field :city
        end

        fields :id, :name
        field :full_name, ->(user) { user.name + user.surname }

        has_one :address, class: Address

        class << self
          def name
            "User"
          end
        end
      end
    end

    it "works correctly" do
      row = subject.process([user, user])

      expect(subject.headings).to eq(["ID", "Name", "Full name", "Address line 1", "City"])
      expect(row.map(&:to_h)).to eq([
        {id: 5, name: "Dan", full_name: "DanMagic", "address.address_line_1": "Ave street", "address.city": "NY"},
        {id: 5, name: "Dan", full_name: "DanMagic", "address.address_line_1": "Ave street", "address.city": "NY"}
      ])
    end
  end

  context "when report with nested `has_many` is provided" do
    let(:report_with_block) do
      Class.new(MagicReport::Report) do
        class << self
          def name
            "User"
          end
        end

        fields :id, :name
        field :full_name, ->(user) { user.name + user.surname }

        has_many :cars, name: :car, prefix: -> { t("car") } do
          field :name
        end
      end
    end
    let(:report) do
      Class.new(MagicReport::Report) do
        class Car < MagicReport::Report
          field :name
        end

        class << self
          def name
            "User"
          end
        end

        fields :id, :name
        field :full_name, ->(user) { user.name + user.surname }

        has_many :cars, class: Car, prefix: -> { t("car") }
      end
    end

    it "works correctly" do
      another_subject = report_with_block.new

      subject.process([user])
      another_subject.process([user])

      expect(subject.headings).to eq(["ID", "Name", "Full name", "Car Name"])
      expect(subject.headings).to eq(another_subject.headings)

      expect(subject.result.flat_map(&:to_h)).to eq(
        [
          {id: 5, name: "Dan", full_name: "DanMagic", "cars.name": "BMW"},
          {id: 5, name: "Dan", full_name: "DanMagic", "cars.name": "Lexus"}
        ]
      )
      expect(subject.result.flat_map(&:to_h)).to eq(another_subject.result.flat_map(&:to_h))

      expect(subject.as_csv.io.read).to eq("ID,Name,Full name,Car Name\n5,Dan,DanMagic,BMW\n5,Dan,DanMagic,Lexus\n")
      expect(subject.as_attachment[:mime_type]).to eq("text/csv")
    end
  end
end
