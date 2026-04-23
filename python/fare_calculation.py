from datetime import datetime
import pytz

def is_rush_hour_india():
    india = pytz.timezone('Asia/Kolkata')
    current_time = datetime.now(india).time()
    
    morning_rush = (8,0)<=(current_time.hour,current_time.minute)<=(11,0)
    evening_rush = (17,0)<=(current_time.hour,current_time.minute)<=(21,0)
    
    return morning_rush or evening_rush

def fare_calculation(distance,vehicle_type,isrush_hour):
    rates = {
        'bike':{'base':15,'per_km':5},
        'auto':{'base':25,'per_km':10},
        'sedan':{'base':50,'per_km':16},
        'suv':{'base':80,'per_km':22},
        'minibus':{'base':90,'per_km':25}
    }
    
    if vehicle_type not in rates:
        raise ValueError("Unknown vehicle type selected.")
    
    if distance <= 0:
        raise ValueError("Distance cannot be negative.")
    
    current_rate = rates[vehicle_type]
    base_fare = current_rate['base']
    distance_fare = current_rate['per_km'] * distance
    
    total_fare = base_fare + distance_fare
    
    if isrush_hour:
        total_fare = total_fare*1.5
        
    return round(total_fare,2)

def print_receipt(vehicle,distance,total_cost,extraFee_applied):
    print("\n"+"="*45)
    print("     FARE CALCULATION TRAVEL RECEIPT     ")
    print("="*45)
    print(f"Vehicle:        {vehicle.capitalize()}")
    print(f"Distance:       {distance} km")
    
    if extraFee_applied:
        print("Note:           Rush hour surge (1.5x)")
    print("-"*45)
    print(f"TOTAL PAYABLE:   ${total_cost}")
    print("="*45+"\n")

def main():
    print("Welcome to Fare Calculation Travel Optimizer!")
    print("Avaliable options: bike , auto , minibus , sedan , suv ")
    
    while True:
        try:
            vehicle_input = input("\nEnter vehicle type (or 'quit' to exit): ").lower().strip()
            
            if vehicle_input=='quit':
                print("Thanks for using Fare Calculation. Goodbye!")
                break
            
            valid_vehicles_lis = ['bike','auto','minibus','sedan','suv']
            if vehicle_input not in valid_vehicles_lis:
                print("Oops! we don't have that vehicle. Try one from the list. ")
                continue
            distance_input = input("How many kilometers is the trip?")
            dis = float(distance_input)
            
            if dis<=0:
                print("Distance must be greater than zero.Try again with correct value")
                continue
                
            is_rush = is_rush_hour_india()
            

            final_fare = fare_calculation(dis,vehicle_input,is_rush)
            print_receipt(vehicle_input,dis,final_fare,is_rush)
            
        except ValueError:
            print("Input Error: Please enter a valid number for distance.")
        except Exception as e:
            print(f"Something went wrong: {e}")

if __name__ == "__main__":
    main()

                
    