def calculate_fare(distance, vehicle_type, is_rush_hour):
    rates = {
        'bike': {'base': 15, 'per_km': 5},
        'auto': {'base': 25, 'per_km': 10},
        'mini': {'base': 40, 'per_km': 14},
        'sedan': {'base': 50, 'per_km': 16},
        'suv': {'base': 80, 'per_km': 22}
    }
    
    if vehicle_type not in rates:
        raise ValueError("Unknown vehicle type selected.")
        
    vehicle_rates = rates[vehicle_type]
    base_fare = vehicle_rates['base']
    dist_fare = vehicle_rates['per_km'] * distance
    
    total_fare = base_fare + dist_fare
    
    if is_rush_hour:
        total_fare = total_fare * 1.5 
        
    return round(total_fare, 2)

def print_receipt(vehicle, distance, total_cost, surge_applied):
    print("\n" + "="*35)
    print("      FARECALC TRAVEL RECEIPT      ")
    print("="*35)
    print(f"Vehicle:        {vehicle.capitalize()}")
    print(f"Distance:       {distance} km")
    if surge_applied:
        print("Note:           Rush hour surge (1.5x)")
    print("-" * 35)
    print(f"TOTAL PAYABLE:  ${total_cost}")
    print("="*35 + "\n")

def main():
    print("Welcome to FareCalc Travel Optimizer!")
    print("Available options: bike, auto, mini, sedan, suv")
    
    while True:
        try:
            veh_input = input("\nEnter vehicle type (or 'quit' to exit): ").lower().strip()
            
            if veh_input == 'quit':
                print("Thanks for using FareCalc. Goodbye!")
                break
                
            valid_vehicles = ['bike', 'auto', 'mini', 'sedan', 'suv']
            if veh_input not in valid_vehicles:
                print("Oops! We don't have that vehicle. Try one from the list.")
                continue
                
            dist_input = input("How many kilometers is the trip? ")
            distance = float(dist_input)
            
            if distance <= 0:
                print("Distance must be greater than zero. Try again.")
                continue
                
            rush_input = input("Is it rush hour right now? (yes/no): ").lower().strip()
            is_surge = True if rush_input in ['yes', 'y'] else False
            
            final_fare = calculate_fare(distance, veh_input, is_surge)
            print_receipt(veh_input, distance, final_fare, is_surge)
            
        except ValueError:
            print("Input error: Please enter a valid number for distance.")
        except Exception as e:
            print(f"Something went wrong: {e}")

if __name__ == "__main__":
    main()
