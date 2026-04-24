from datetime import datetime

def calculate_fare(km, vehicle_type, hour):
    rates = {
        'economy': 10,
        'premium': 18,
        'suv': 25
    }

    base_fare = rates[vehicle_type] * km

    if 17 <= hour <= 20:
        base_fare *= 1.5

    return round(base_fare, 2)


def main():
    print("Welcome to CityCab Fare Calculator")

    rates = {
        'economy': 10,
        'premium': 18,
        'suv': 25
    }

    while True:
        vehicle = input("Enter vehicle type (economy/premium/suv or quit): ").lower()

        if vehicle == 'quit':
            break
        if vehicle not in rates:
            print("Service Not Available")
            continue

        try:
            km = float(input("Enter distance (km): "))

            hour = datetime.now().hour
            print(f"Current Hour: {hour}")

            fare = calculate_fare(km, vehicle, hour)

            print("\n----- PRICE RECEIPT -----")
            print(f"Vehicle: {vehicle}")
            print(f"Distance: {km} km")
            print(f"Total Fare: ₹{fare}")
            print("-------------------------\n")

            break

        except:
            print("Invalid input. Try again.")


if __name__ == "__main__":
    main()