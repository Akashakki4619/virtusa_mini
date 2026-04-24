import java.util.Scanner;

public class PasswordValidator {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        boolean valid = false;
        System.out.println("The password minimum length should be 8");
        System.out.println("The password should contain at least one uppercase letter");
        System.out.println("The password should contain at least one number");
        while (!valid) {
            System.out.println("Enter password: ");
            String pass = sc.nextLine();
            if (pass.length() < 8) {
                System.out.println("The password is too short");
                continue;
            }

            boolean hasUpper = false;
            boolean hasDigit = false;
            int n = pass.length();

            for (int i = 0; i < n; i++) {
                char ch = pass.charAt(i);

                if (Character.isUpperCase(ch)) {
                    hasUpper = true;
                }
                if (Character.isDigit(ch)) {
                    hasDigit = true;
                }
                if (hasDigit && hasUpper) {
                    break;
                }
            }
            if (!hasUpper && !hasDigit) {
                System.out.println("The password is missing an uppercase letter and a digit.");
            } else if (!hasDigit) {
                System.out.println("The password is missing a digit.");
            } else if (!hasUpper) {
                System.out.println("The password is missing an uppercase letter.");
            } else {
                valid = true;
                System.out.println("Password accepted.");
            }
        }
        sc.close();
    }
}
