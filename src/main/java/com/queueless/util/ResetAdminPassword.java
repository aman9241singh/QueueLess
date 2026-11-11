package com.queueless.util;
public class ResetAdminPassword {
    public static void main(String[] args) {
        String newPassword = "Aman@9241";
        System.out.println(PasswordUtil.hashPassword(newPassword));
    }
}