import java.util.Scanner;

interface Billable {
    double calculateTotal(int units);
}

class UtilityBill implements Billable {

    public double calculateTotal(int units) {
        double amount;

        if (units <= 100) {
            amount = units * 1.0;
        } else if (units <= 300) {
            amount = (100 * 1.0) + ((units - 100) * 2.0);
        } else {
            amount = (100 * 1.0) + (200 * 2.0) + ((units - 300) * 5.0);
        }

        return amount;
    }
}

public class BillGenerator {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        UtilityBill bill = new UtilityBill();

        while (true) {
            System.out.println("\nEnter Customer Name (or type 'exit' to stop):");
            String name = sc.nextLine();

            if (name.equalsIgnoreCase("exit")) {
                System.out.println("Exiting... Thank you!");
                break;
            }

            try {
                System.out.println("Enter Previous Meter Reading:");
                int prev = Integer.parseInt(sc.nextLine());

                System.out.println("Enter Current Meter Reading:");
                int curr = Integer.parseInt(sc.nextLine());

                if (prev < 0 || curr < 0) {
                    System.out.println("Meter readings cannot be negative.");
                    continue;
                }

                if (curr < prev) {
                    System.out.println("Error: Current reading cannot be less than previous reading.");
                    continue;
                }

                int units = curr - prev;

                double total = bill.calculateTotal(units);

                double tax = total * 0.10;
                double finalAmount = total + tax;

                System.out.println("\n========== DIGITAL RECEIPT ==========");
                System.out.println("Customer Name : " + name);
                System.out.println("Units Consumed: " + units);
                System.out.println("Base Amount   : $" + String.format("%.2f", total));
                System.out.println("Tax (10%)     : $" + String.format("%.2f", tax));
                System.out.println("-------------------------------------");
                System.out.println("Final Total   : $" + String.format("%.2f", finalAmount));
                System.out.println("=====================================");

            } catch (NumberFormatException e) {
                System.out.println("Invalid input. Please enter numeric values only.");
            }
        }

        sc.close();
    }
}