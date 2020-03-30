
import 'dart:math';
import 'dart:typed_data';
import "package:pointycastle/export.dart";

class Crypto {


    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
        SecureRandom secureRandom,
        {int bitLength = 2048}) {
        // Create an RSA key generator and initialize it

        final keyGen = RSAKeyGenerator()
            ..init(ParametersWithRandom(
                RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
                secureRandom));

        // Use the generator

        final pair = keyGen.generateKeyPair();

        // Cast the generated key pair into the RSA key types

        final myPublic = pair.publicKey as RSAPublicKey;
        final myPrivate = pair.privateKey as RSAPrivateKey;

        return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
            myPublic, myPrivate);
    }

    SecureRandom exampleSecureRandom() {
        final secureRandom = FortunaRandom();

        final seedSource = Random.secure();
        final seeds = <int>[];
        for (int i = 0; i < 32; i++) {
            seeds.add(seedSource.nextInt(255));
        }
        secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

        return secureRandom;
    }

    AsymmetricKeyPair<PublicKey, PrivateKey> getRSA() {
        final pair = generateRSAkeyPair(exampleSecureRandom());
        //final public = pair.publicKey;
        //final private = pair.privateKey;
        return pair;
    }
    Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
        final encryptor = OAEPEncoding(RSAEngine())
            ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

        return _processInBlocks(encryptor, dataToEncrypt);
    }

    Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
        final decryptor = OAEPEncoding(RSAEngine())
            ..init(false, PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

        return _processInBlocks(decryptor, cipherText);
    }

    Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
        final numBlocks = input.length ~/ engine.inputBlockSize +
            ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

        final output = Uint8List(numBlocks * engine.outputBlockSize);

        var inputOffset = 0;
        var outputOffset = 0;
        while (inputOffset < input.length) {
            final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
                ? engine.inputBlockSize
                : input.length - inputOffset;

            outputOffset += engine.processBlock(
                input, inputOffset, chunkSize, output, outputOffset);

            inputOffset += chunkSize;
        }

        return (output.length == outputOffset)
            ? output
            : output.sublist(0, outputOffset);
    }

    Uint8List convertString(String message)
    {

        List<int> list = message.codeUnits;
        Uint8List bytes = Uint8List.fromList(list);
        return bytes;

    }
    String convertUint8List(Uint8List bytes)
    {
        String message = String.fromCharCodes(bytes);
        return message;
    }


}