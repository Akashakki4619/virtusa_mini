import java.util.Scanner;

public class SafeLoginValidator {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        boolean correct = false;
        int maxiTries = 3;
        int currentTry = 0;

        System.out.println("=== SafeLog Password Setup ===");
        System.out.println("Your new password must have:");
        System.out.println("1. At least 8 characters");
        System.out.println("2. At least one uppercase letter");
        System.out.println("3. At least one digit");
        System.out.println("--------------------------------");

        while (!correct && currentTry < maxiTries) {
            System.out.println("Please enter a passWord: ");
            String pass = sc.nextLine();
            currentTry++;

            // Length check first
            if (pass.length() < 8) {
                System.out.println("Oops! Password is too short. It needs to be 8 characters or more.");
                if (currentTry < maxiTries) {
                    System.out.println("Tries remaining: " + (maxiTries - currentTry));
                }
                continue;
            }

            // Check for UpperCase and Number
            boolean boolUpper = false;
            boolean boolNum = false;
            int n = pass.length();
            for (int i = 0; i < n; i++) {
                char ch = pass.charAt(i);
                // Condition to check for UpperCase character
                if (Character.isUpperCase(ch)) {
                    boolUpper = true;
                }

                // Condition to check for a Digit
                if (Character.isDigit(ch)) {
                    boolNum = true;
                }
            }

            // FeedBack to the User
            if (!boolUpper && !boolNum) {
                System.out.println("Error! Password is missing both an UpperCase letter and a Digit");
            } else if (!boolUpper) {
                System.out.println("Error! Password is missing an UpperCase letter");
            } else if (!boolNum) {
                System.out.println("Error! You need to include Atleast one digit to the Password");
            } else {
                correct = true;
                System.out.println("Awasome! Password is Strong and is Accepted");
            }

            if (!correct && currentTry < maxiTries) {
                System.out.println("Tries remaining: " + (maxiTries - currentTry));
            }
        }
        if (!correct) {
            System.out.println("Too many Failed attempts. Try again later");
        }
        sc.close();
    }
}
