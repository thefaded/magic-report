# frozen_string_literal: true

RSpec.describe MagicReport::Report do
  let(:subject) { report }

  let(:user) do
    OpenStruct.new(
      id: 5,
      name: "Dan",
      surname: "Magic",
      address: OpenStruct.new(address_line_1: "Ave street", city: "NY"),
      shipping_address: OpenStruct.new(address_line_1: "Clucky street", city: "SF"),
      cars: [
        OpenStruct.new(name: "BMW", price: OpenStruct.new(amount: 5000)),
        OpenStruct.new(name: "Lexus", price: OpenStruct.new(amount: 6000))
      ]
    )
  end

  context "when report with only `fields` is provided" do
    let(:report) do
      Class.new(MagicReport::Report) do
        fields :id
        field :name, :format_name
        field :full_name, proc { |user| user.name + user.surname }

        def format_name(record, name)
          "Hello " + name
        end

        class << self
          def name
            "User"
          end
        end
      end
    end

    it "works correctly" do
      report = subject.new(user)
      row = report.rows.first

      expect(row.to_a).to eq([5, "Hello Dan", "DanMagic"])
      expect(row.headings).to eq(["ID", "Name", "Full name"])
    end
  end

  context "when report with `has_one` is provided" do
    let(:report) do
      Class.new(MagicReport::Report) do
        def self.name
          "User"
        end

        class Address < MagicReport::Report
          field :address_line_1
          field :city
        end

        fields :id, :name
        field :full_name, proc { |user| user.name + user.surname }

        has_one :address, class: Address
        has_one :shipping_address do
          field :address_line_1
          field :city
        end

        has_many :cars do
          field :name
          field :price, proc { |car| car.price.amount }
        end
      end
    end

    it "works correctly" do
      report = subject.new(user)

      expect(report.rows.count).to eq(2)
      expect(report.rows.map(&:to_a)).to eq([
        [5, "Dan", "DanMagic", "Ave street", "NY", "Clucky street", "SF", "BMW", 5000],
        [nil, nil, nil, nil, nil, nil, nil, "Lexus", 6000]
      ])
      expect(report.headings).to eq([
        "ID",
        "Name",
        "Full name",
        "My home address Address line 1",
        "My home address City",
        "My ship Address line 1",
        "My ship City",
        "Car Name",
        "Car Price"
      ])
    end

    context "when single entry provided for `has_many` relation" do
      it "returns correctly" do
        user.cars = [user.cars.first]

        report = subject.new(user)

        expect(report.rows.count).to eq(1)
        expect(report.rows.map(&:to_a)).to eq([
          [5, "Dan", "DanMagic", "Ave street", "NY", "Clucky street", "SF", "BMW", 5000]
        ])
      end
    end

    context "CSV" do
      it "correctly represents report as CSV" do
        report = subject.new(user)

        expect(report.as_attachment[:content]).to eq("ID,Name,Full name,My home address Address line 1,My home address City,My ship Address line 1,My ship City,Car Name,Car Price\n5,Dan,DanMagic,Ave street,NY,Clucky street,SF,BMW,5000\n,,,,,,,Lexus,6000\n")
      end
    end
  end
end
