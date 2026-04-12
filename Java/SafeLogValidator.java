import java.util.Scanner;

public class SafeLogValidator {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        boolean passed = false;
        int maxTries = 3;
        int currentTry = 0;

        System.out.println("=== SafeLog Password Setup ===");
        System.out.println("Your new password must have:");
        System.out.println("1. At least 8 characters");
        System.out.println("2. At least one uppercase letter");
        System.out.println("3. At least one digit");
        System.out.println("--------------------------------");

        while (!passed && currentTry < maxTries) {
            System.out.print("\nPlease enter a password: ");
            String pwd = sc.nextLine();
            currentTry++;

            // basic length check first
            if (pwd.length() < 8) {
                System.out.println("Oops: Password is too short! It needs to be 8 characters or more.");
                System.out.println("Tries remaining: " + (maxTries - currentTry));
                continue;
            }

            // manual check for uppercase and numbers
            boolean foundUpper = false;
            boolean foundNumber = false;

            for (int i = 0; i < pwd.length(); i++) {
                char ch = pwd.charAt(i);
                
                if (Character.isUpperCase(ch)) {
                    foundUpper = true;
                }
                
                if (Character.isDigit(ch)) {
                    foundNumber = true;
                }
            }

            // give specific feedback
            if (!foundUpper && !foundNumber) {
                System.out.println("Error: Password is missing both an uppercase letter and a number.");
            } else if (!foundUpper) {
                System.out.println("Error: You forgot to include an uppercase letter.");
            } else if (!foundNumber) {
                System.out.println("Error: You need at least one number in there.");
            } else {
                passed = true;
                System.out.println("Awesome! Password looks good and is accepted.");
            }

            if (!passed && currentTry < maxTries) {
                System.out.println("Tries remaining: " + (maxTries - currentTry));
            }
        }

        if (!passed) {
            System.out.println("\nToo many failed attempts. Try again later.");
        }

        sc.close();
    }
}
