package com.example.chatapp;

import java.math.BigInteger;
import java.util.Random;

public class Libraries {
    public static BigInteger P;
    public static BigInteger Q;
    public static BigInteger N;
    private static BigInteger PHI;
    public static BigInteger e;
    public static BigInteger d;
    private static int maxLength = 1024;
    private static Random R;

    public Libraries() {
    }

    public static BigInteger[] getkey() {
        BigInteger[] key = new BigInteger[3];
        R = new Random();
        P = BigInteger.probablePrime(maxLength, R);
        Q = BigInteger.probablePrime(maxLength, R);
        N = P.multiply(Q);
        PHI = P.subtract(BigInteger.ONE).multiply(Q.subtract(BigInteger.ONE));
        e = BigInteger.probablePrime(maxLength / 2, R);

        while (PHI.gcd(e).compareTo(BigInteger.ONE) > 0 && e.compareTo(PHI) < 0) {
            e.add(BigInteger.ONE);
        }

        d = e.modInverse(PHI);
        key[0] = e;
        key[1] = d;
        key[2] = N;
        return key;
    }


    public static BigInteger encryptrsa(byte[] message, BigInteger e, BigInteger N) {
        return (new BigInteger(message)).modPow(e, N);
    }

    public static BigInteger decryptrsa(BigInteger message, BigInteger d, BigInteger N) {
        return (message).modPow(d, N);
    }

    public static byte[] decryptmcc(byte[] text, int key) {
        int temp;
        for (int i = 0; i < text.length; i++) {
            temp = (text[i]-key*(i+1))%128;
            if (temp>0)
                text[i] = (byte)temp;
            else
                temp+=128;text[i] = (byte)temp;
        }
        return text;
    }

    public static byte[] encryptmcc(String text, int key) {
        byte[] bytes = text.getBytes();
        int temp;
        for (int i = 0; i < bytes.length; i++) {
            temp = (bytes[i]+key*(i+1))%128;
            bytes[i] = (byte)temp ;

        }
        return bytes;
    }
}
