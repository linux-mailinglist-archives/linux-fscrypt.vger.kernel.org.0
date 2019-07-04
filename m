Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 611495FCF1
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Jul 2019 20:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfGDSax (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Jul 2019 14:30:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40623 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfGDSaw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Jul 2019 14:30:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so7012570wmj.5
        for <linux-fscrypt@vger.kernel.org>; Thu, 04 Jul 2019 11:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5DZWOLEffXo8pC7WTyqnGc7M3CXsT0msBRLmCm3I2z0=;
        b=UbVRJRUu+aK1+NeGzaTFgn3c42Aoco5HTDC/sVHVvn94PhnbPdNUf/YI8DeUsZq2IX
         bsyNxj6ZBpMwCcAzTGpwO1ojlRpPbHsHTpcvLusxYF6QsZyPqI+AgZzC5B9h/Cg0Ruq+
         8NJ4moDVmwejkv/D9y0kVopGK0HHRLVCbMFex7dInuwKeXO/Z4/utZrB2afW2xAExYb6
         jrjQMpmmdsAGx6+ow2m90icC1GMAbTTeSr5Pfxe230AJfKlWQHOsa5IXV+4jCTkSMPp1
         MIL1dLeNwF8ozJ5RCy6oBu/r0TbNxAPewbB03cfCwNalETx6ZKT6VvZZh1hYvXArBDnG
         mJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5DZWOLEffXo8pC7WTyqnGc7M3CXsT0msBRLmCm3I2z0=;
        b=rer0LhMdhgd82CKWwlxefBbiQUnO7HEfYm3eO8D8CcdR1Qc4yLTREHAkD8EXfvy0UX
         2WaTf8jHFDiUyfyac9o3zNWf6PNk5ByJ437gmIzTxF2S7LJHqWcBqJdTfnsOdIAVwCyS
         eVM5uRwaZPtegFOrr/CC9kmgjlBh+fY5dkggGfssoU1zeBHc07KYlwVTZNDhkO534ud2
         RBOIw8X3Ph4YY2BYbtE3I5nYqz6iC2IcOwXE1XXXJ9PJ0csIker+2uaHtYMTPNEY3qfB
         5G3uFikrxkwU+0gVITLse4jIC0KdxZ0YH2DzBtyvzMheKj0A49T0j58MoiB3EbJKmX5E
         2RjQ==
X-Gm-Message-State: APjAAAXZQxg0qAxDvze0jATBvE+/fPB3+0+S2IMhS7VGbne3rT7ceWq9
        FNaCDDVAnzFa6sTmqb0gZig3Xg==
X-Google-Smtp-Source: APXvYqz7lWF5SEJspvp6whJpfm/gz+ND0wnhSzJyiAU2F0KUKw1ceT7zZcJ//r30TsawbeMsTs+yjQ==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr586469wmg.86.1562265048493;
        Thu, 04 Jul 2019 11:30:48 -0700 (PDT)
Received: from e111045-lin.arm.com (93-143-123-179.adsl.net.t-com.hr. [93.143.123.179])
        by smtp.gmail.com with ESMTPSA id o6sm11114695wra.27.2019.07.04.11.30.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 11:30:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v8 5/7] crypto: essiv - add test vector for essiv(cbc(aes),aes,sha256)
Date:   Thu,  4 Jul 2019 20:30:15 +0200
Message-Id: <20190704183017.31570-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
References: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add a test vector for the ESSIV mode that is the most widely used,
i.e., using cbc(aes) and sha256, in both skcipher and AEAD modes
(the latter is used by tcrypt to encapsulate the authenc template
or h/w instantiations of the same)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/tcrypt.c  |   9 +
 crypto/testmgr.c |  14 +
 crypto/testmgr.h | 497 ++++++++++++++++++++
 3 files changed, 520 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 798253f05203..5c8d585c2ad1 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2332,6 +2332,15 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				  0, speed_template_32);
 		break;
 
+	case 220:
+		test_acipher_speed("essiv(cbc(aes),aes,sha256)",
+				  ENCRYPT, sec, NULL, 0,
+				  speed_template_16_24_32);
+		test_acipher_speed("essiv(cbc(aes),aes,sha256)",
+				  DECRYPT, sec, NULL, 0,
+				  speed_template_16_24_32);
+		break;
+
 	case 300:
 		if (alg) {
 			test_hash_speed(alg, sec, generic_hash_speed_template);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d760f5cd35b2..304261a2e577 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4561,6 +4561,20 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.akcipher = __VECS(ecrdsa_tv_template)
 		}
+	}, {
+		.alg = "essiv(authenc(hmac(sha256),cbc(aes)),aes,sha256)",
+		.test = alg_test_aead,
+		.fips_allowed = 1,
+		.suite = {
+			.aead = __VECS(essiv_hmac_sha256_aes_cbc_tv_temp)
+		}
+	}, {
+		.alg = "essiv(cbc(aes),aes,sha256)",
+		.test = alg_test_skcipher,
+		.fips_allowed = 1,
+		.suite = {
+			.cipher = __VECS(essiv_aes_cbc_tv_template)
+		}
 	}, {
 		.alg = "gcm(aes)",
 		.generic_driver = "gcm_base(ctr(aes-generic),ghash-generic)",
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 6b459a6a796b..193cf2e9badd 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -33686,4 +33686,501 @@ static const struct comp_testvec zstd_decomp_tv_template[] = {
 			  "functions.",
 	},
 };
+
+/* based on aes_cbc_tv_template */
+static const struct cipher_testvec essiv_aes_cbc_tv_template[] = {
+	{
+		.key    = "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
+			  "\x51\x2e\x03\xd5\x34\x12\x00\x06",
+		.klen   = 16,
+		.iv	= "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext	= "Single block msg",
+		.ctext	= "\xfa\x59\xe7\x5f\x41\x56\x65\xc3"
+			  "\x36\xca\x6b\x72\x10\x9f\x8c\xd4",
+		.len	= 16,
+	}, {
+		.key    = "\xc2\x86\x69\x6d\x88\x7c\x9a\xa0"
+			  "\x61\x1b\xbb\x3e\x20\x25\xa4\x5a",
+		.klen   = 16,
+		.iv     = "\x56\x2e\x17\x99\x6d\x09\x3d\x28"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.ctext	= "\xc8\x59\x9a\xfe\x79\xe6\x7b\x20"
+			  "\x06\x7d\x55\x0a\x5e\xc7\xb5\xa7"
+			  "\x0b\x9c\x80\xd2\x15\xa1\xb8\x6d"
+			  "\xc6\xab\x7b\x65\xd9\xfd\x88\xeb",
+		.len	= 32,
+	}, {
+		.key	= "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
+			  "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
+			  "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
+		.klen	= 24,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ctext	= "\x96\x6d\xa9\x7a\x42\xe6\x01\xc7"
+			  "\x17\xfc\xa7\x41\xd3\x38\x0b\xe5"
+			  "\x51\x48\xf7\x7e\x5e\x26\xa9\xfe"
+			  "\x45\x72\x1c\xd9\xde\xab\xf3\x4d"
+			  "\x39\x47\xc5\x4f\x97\x3a\x55\x63"
+			  "\x80\x29\x64\x4c\x33\xe8\x21\x8a"
+			  "\x6a\xef\x6b\x6a\x8f\x43\xc0\xcb"
+			  "\xf0\xf3\x6e\x74\x54\x44\x92\x44",
+		.len	= 64,
+	}, {
+		.key	= "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
+			  "\x2b\x73\xae\xf0\x85\x7d\x77\x81"
+			  "\x1f\x35\x2c\x07\x3b\x61\x08\xd7"
+			  "\x2d\x98\x10\xa3\x09\x14\xdf\xf4",
+		.klen	= 32,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ctext	= "\x24\x52\xf1\x48\x74\xd0\xa7\x93"
+			  "\x75\x9b\x63\x46\xc0\x1c\x1e\x17"
+			  "\x4d\xdc\x5b\x3a\x27\x93\x2a\x63"
+			  "\xf7\xf1\xc7\xb3\x54\x56\x5b\x50"
+			  "\xa3\x31\xa5\x8b\xd6\xfd\xb6\x3c"
+			  "\x8b\xf6\xf2\x45\x05\x0c\xc8\xbb"
+			  "\x32\x0b\x26\x1c\xe9\x8b\x02\xc0"
+			  "\xb2\x6f\x37\xa7\x5b\xa8\xa9\x42",
+		.len	= 64,
+	}, {
+		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55"
+			  "\x0F\x32\x55\x78\x9B\xBE\x78\x9B"
+			  "\xBE\xE1\x04\x27\xE1\x04\x27\x4A"
+			  "\x6D\x90\x4A\x6D\x90\xB3\xD6\xF9",
+		.klen	= 32,
+		.iv	= "\xE7\x82\x1D\xB8\x53\x11\xAC\x47"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext	= "\x50\xB9\x22\xAE\x17\x80\x0C\x75"
+			  "\xDE\x47\xD3\x3C\xA5\x0E\x9A\x03"
+			  "\x6C\xF8\x61\xCA\x33\xBF\x28\x91"
+			  "\x1D\x86\xEF\x58\xE4\x4D\xB6\x1F"
+			  "\xAB\x14\x7D\x09\x72\xDB\x44\xD0"
+			  "\x39\xA2\x0B\x97\x00\x69\xF5\x5E"
+			  "\xC7\x30\xBC\x25\x8E\x1A\x83\xEC"
+			  "\x55\xE1\x4A\xB3\x1C\xA8\x11\x7A"
+			  "\x06\x6F\xD8\x41\xCD\x36\x9F\x08"
+			  "\x94\xFD\x66\xF2\x5B\xC4\x2D\xB9"
+			  "\x22\x8B\x17\x80\xE9\x52\xDE\x47"
+			  "\xB0\x19\xA5\x0E\x77\x03\x6C\xD5"
+			  "\x3E\xCA\x33\x9C\x05\x91\xFA\x63"
+			  "\xEF\x58\xC1\x2A\xB6\x1F\x88\x14"
+			  "\x7D\xE6\x4F\xDB\x44\xAD\x16\xA2"
+			  "\x0B\x74\x00\x69\xD2\x3B\xC7\x30"
+			  "\x99\x02\x8E\xF7\x60\xEC\x55\xBE"
+			  "\x27\xB3\x1C\x85\x11\x7A\xE3\x4C"
+			  "\xD8\x41\xAA\x13\x9F\x08\x71\xFD"
+			  "\x66\xCF\x38\xC4\x2D\x96\x22\x8B"
+			  "\xF4\x5D\xE9\x52\xBB\x24\xB0\x19"
+			  "\x82\x0E\x77\xE0\x49\xD5\x3E\xA7"
+			  "\x10\x9C\x05\x6E\xFA\x63\xCC\x35"
+			  "\xC1\x2A\x93\x1F\x88\xF1\x5A\xE6"
+			  "\x4F\xB8\x21\xAD\x16\x7F\x0B\x74"
+			  "\xDD\x46\xD2\x3B\xA4\x0D\x99\x02"
+			  "\x6B\xF7\x60\xC9\x32\xBE\x27\x90"
+			  "\x1C\x85\xEE\x57\xE3\x4C\xB5\x1E"
+			  "\xAA\x13\x7C\x08\x71\xDA\x43\xCF"
+			  "\x38\xA1\x0A\x96\xFF\x68\xF4\x5D"
+			  "\xC6\x2F\xBB\x24\x8D\x19\x82\xEB"
+			  "\x54\xE0\x49\xB2\x1B\xA7\x10\x79"
+			  "\x05\x6E\xD7\x40\xCC\x35\x9E\x07"
+			  "\x93\xFC\x65\xF1\x5A\xC3\x2C\xB8"
+			  "\x21\x8A\x16\x7F\xE8\x51\xDD\x46"
+			  "\xAF\x18\xA4\x0D\x76\x02\x6B\xD4"
+			  "\x3D\xC9\x32\x9B\x04\x90\xF9\x62"
+			  "\xEE\x57\xC0\x29\xB5\x1E\x87\x13"
+			  "\x7C\xE5\x4E\xDA\x43\xAC\x15\xA1"
+			  "\x0A\x73\xFF\x68\xD1\x3A\xC6\x2F"
+			  "\x98\x01\x8D\xF6\x5F\xEB\x54\xBD"
+			  "\x26\xB2\x1B\x84\x10\x79\xE2\x4B"
+			  "\xD7\x40\xA9\x12\x9E\x07\x70\xFC"
+			  "\x65\xCE\x37\xC3\x2C\x95\x21\x8A"
+			  "\xF3\x5C\xE8\x51\xBA\x23\xAF\x18"
+			  "\x81\x0D\x76\xDF\x48\xD4\x3D\xA6"
+			  "\x0F\x9B\x04\x6D\xF9\x62\xCB\x34"
+			  "\xC0\x29\x92\x1E\x87\xF0\x59\xE5"
+			  "\x4E\xB7\x20\xAC\x15\x7E\x0A\x73"
+			  "\xDC\x45\xD1\x3A\xA3\x0C\x98\x01"
+			  "\x6A\xF6\x5F\xC8\x31\xBD\x26\x8F"
+			  "\x1B\x84\xED\x56\xE2\x4B\xB4\x1D"
+			  "\xA9\x12\x7B\x07\x70\xD9\x42\xCE"
+			  "\x37\xA0\x09\x95\xFE\x67\xF3\x5C"
+			  "\xC5\x2E\xBA\x23\x8C\x18\x81\xEA"
+			  "\x53\xDF\x48\xB1\x1A\xA6\x0F\x78"
+			  "\x04\x6D\xD6\x3F\xCB\x34\x9D\x06"
+			  "\x92\xFB\x64\xF0\x59\xC2\x2B\xB7"
+			  "\x20\x89\x15\x7E\xE7\x50\xDC\x45"
+			  "\xAE\x17\xA3\x0C\x75\x01\x6A\xD3"
+			  "\x3C\xC8\x31\x9A\x03\x8F\xF8\x61"
+			  "\xED\x56\xBF\x28\xB4\x1D\x86\x12",
+		.ctext	= "\x97\x7f\x69\x0f\x0f\x34\xa6\x33"
+			  "\x66\x49\x7e\xd0\x4d\x1b\xc9\x64"
+			  "\xf9\x61\x95\x98\x11\x00\x88\xf8"
+			  "\x2e\x88\x01\x0f\x2b\xe1\xae\x3e"
+			  "\xfe\xd6\x47\x30\x11\x68\x7d\x99"
+			  "\xad\x69\x6a\xe8\x41\x5f\x1e\x16"
+			  "\x00\x3a\x47\xdf\x8e\x7d\x23\x1c"
+			  "\x19\x5b\x32\x76\x60\x03\x05\xc1"
+			  "\xa0\xff\xcf\xcc\x74\x39\x46\x63"
+			  "\xfe\x5f\xa6\x35\xa7\xb4\xc1\xf9"
+			  "\x4b\x5e\x38\xcc\x8c\xc1\xa2\xcf"
+			  "\x9a\xc3\xae\x55\x42\x46\x93\xd9"
+			  "\xbd\x22\xd3\x8a\x19\x96\xc3\xb3"
+			  "\x7d\x03\x18\xf9\x45\x09\x9c\xc8"
+			  "\x90\xf3\x22\xb3\x25\x83\x9a\x75"
+			  "\xbb\x04\x48\x97\x3a\x63\x08\x04"
+			  "\xa0\x69\xf6\x52\xd4\x89\x93\x69"
+			  "\xb4\x33\xa2\x16\x58\xec\x4b\x26"
+			  "\x76\x54\x10\x0b\x6e\x53\x1e\xbc"
+			  "\x16\x18\x42\xb1\xb1\xd3\x4b\xda"
+			  "\x06\x9f\x8b\x77\xf7\xab\xd6\xed"
+			  "\xa3\x1d\x90\xda\x49\x38\x20\xb8"
+			  "\x6c\xee\xae\x3e\xae\x6c\x03\xb8"
+			  "\x0b\xed\xc8\xaa\x0e\xc5\x1f\x90"
+			  "\x60\xe2\xec\x1b\x76\xd0\xcf\xda"
+			  "\x29\x1b\xb8\x5a\xbc\xf4\xba\x13"
+			  "\x91\xa6\xcb\x83\x3f\xeb\xe9\x7b"
+			  "\x03\xba\x40\x9e\xe6\x7a\xb2\x4a"
+			  "\x73\x49\xfc\xed\xfb\x55\xa4\x24"
+			  "\xc7\xa4\xd7\x4b\xf5\xf7\x16\x62"
+			  "\x80\xd3\x19\x31\x52\x25\xa8\x69"
+			  "\xda\x9a\x87\xf5\xf2\xee\x5d\x61"
+			  "\xc1\x12\x72\x3e\x52\x26\x45\x3a"
+			  "\xd8\x9d\x57\xfa\x14\xe2\x9b\x2f"
+			  "\xd4\xaa\x5e\x31\xf4\x84\x89\xa4"
+			  "\xe3\x0e\xb0\x58\x41\x75\x6a\xcb"
+			  "\x30\x01\x98\x90\x15\x80\xf5\x27"
+			  "\x92\x13\x81\xf0\x1c\x1e\xfc\xb1"
+			  "\x33\xf7\x63\xb0\x67\xec\x2e\x5c"
+			  "\x85\xe3\x5b\xd0\x43\x8a\xb8\x5f"
+			  "\x44\x9f\xec\x19\xc9\x8f\xde\xdf"
+			  "\x79\xef\xf8\xee\x14\x87\xb3\x34"
+			  "\x76\x00\x3a\x9b\xc7\xed\xb1\x3d"
+			  "\xef\x07\xb0\xe4\xfd\x68\x9e\xeb"
+			  "\xc2\xb4\x1a\x85\x9a\x7d\x11\x88"
+			  "\xf8\xab\x43\x55\x2b\x8a\x4f\x60"
+			  "\x85\x9a\xf4\xba\xae\x48\x81\xeb"
+			  "\x93\x07\x97\x9e\xde\x2a\xfc\x4e"
+			  "\x31\xde\xaa\x44\xf7\x2a\xc3\xee"
+			  "\x60\xa2\x98\x2c\x0a\x88\x50\xc5"
+			  "\x6d\x89\xd3\xe4\xb6\xa7\xf4\xb0"
+			  "\xcf\x0e\x89\xe3\x5e\x8f\x82\xf4"
+			  "\x9d\xd1\xa9\x51\x50\x8a\xd2\x18"
+			  "\x07\xb2\xaa\x3b\x7f\x58\x9b\xf4"
+			  "\xb7\x24\x39\xd3\x66\x2f\x1e\xc0"
+			  "\x11\xa3\x56\x56\x2a\x10\x73\xbc"
+			  "\xe1\x23\xbf\xa9\x37\x07\x9c\xc3"
+			  "\xb2\xc9\xa8\x1c\x5b\x5c\x58\xa4"
+			  "\x77\x02\x26\xad\xc3\x40\x11\x53"
+			  "\x93\x68\x72\xde\x05\x8b\x10\xbc"
+			  "\xa6\xd4\x1b\xd9\x27\xd8\x16\x12"
+			  "\x61\x2b\x31\x2a\x44\x87\x96\x58",
+		.len	= 496,
+	},
+};
+
+/* based on hmac_sha256_aes_cbc_tv_temp */
+static const struct aead_testvec essiv_hmac_sha256_aes_cbc_tv_temp[] = {
+	{
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"		/* rta type */
+#endif
+			  "\x00\x00\x00\x10"	/* enc key length */
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
+			  "\x51\x2e\x03\xd5\x34\x12\x00\x06",
+		.klen   = 8 + 32 + 16,
+		.iv     = "\xb3\x0c\x5a\x11\x41\xad\xc1\x04"
+			  "\xbc\x1e\x7e\x35\xb0\x5d\x78\x29",
+		.assoc	= "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
+			  "\xb4\x22\xda\x80\x2c\x9f\xac\x41",
+		.alen	= 16,
+		.ptext	= "Single block msg",
+		.plen	= 16,
+		.ctext	= "\xe3\x53\x77\x9c\x10\x79\xae\xb8"
+			  "\x27\x08\x94\x2d\xbe\x77\x18\x1a"
+			  "\xcc\xde\x2d\x6a\xae\xf1\x0b\xcc"
+			  "\x38\x06\x38\x51\xb4\xb8\xf3\x5b"
+			  "\x5c\x34\xa6\xa3\x6e\x0b\x05\xe5"
+			  "\x6a\x6d\x44\xaa\x26\xa8\x44\xa5",
+		.clen	= 16 + 32,
+	}, {
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"		/* rta type */
+#endif
+			  "\x00\x00\x00\x10"	/* enc key length */
+			  "\x20\x21\x22\x23\x24\x25\x26\x27"
+			  "\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f"
+			  "\x30\x31\x32\x33\x34\x35\x36\x37"
+			  "\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f"
+			  "\xc2\x86\x69\x6d\x88\x7c\x9a\xa0"
+			  "\x61\x1b\xbb\x3e\x20\x25\xa4\x5a",
+		.klen   = 8 + 32 + 16,
+		.iv     = "\x56\xe8\x14\xa5\x74\x18\x75\x13"
+			  "\x2f\x79\xe7\xc8\x65\xe3\x48\x45",
+		.assoc	= "\x56\x2e\x17\x99\x6d\x09\x3d\x28"
+			  "\xdd\xb3\xba\x69\x5a\x2e\x6f\x58",
+		.alen	= 16,
+		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.plen	= 32,
+		.ctext	= "\xd2\x96\xcd\x94\xc2\xcc\xcf\x8a"
+			  "\x3a\x86\x30\x28\xb5\xe1\xdc\x0a"
+			  "\x75\x86\x60\x2d\x25\x3c\xff\xf9"
+			  "\x1b\x82\x66\xbe\xa6\xd6\x1a\xb1"
+			  "\xf5\x33\x53\xf3\x68\x85\x2a\x99"
+			  "\x0e\x06\x58\x8f\xba\xf6\x06\xda"
+			  "\x49\x69\x0d\x5b\xd4\x36\x06\x62"
+			  "\x35\x5e\x54\x58\x53\x4d\xdf\xbf",
+		.clen	= 32 + 32,
+	}, {
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"            /* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"		/* rta type */
+#endif
+			  "\x00\x00\x00\x10"	/* enc key length */
+			  "\x11\x22\x33\x44\x55\x66\x77\x88"
+			  "\x99\xaa\xbb\xcc\xdd\xee\xff\x11"
+			  "\x22\x33\x44\x55\x66\x77\x88\x99"
+			  "\xaa\xbb\xcc\xdd\xee\xff\x11\x22"
+			  "\x6c\x3e\xa0\x47\x76\x30\xce\x21"
+			  "\xa2\xce\x33\x4a\xa7\x46\xc2\xcd",
+		.klen   = 8 + 32 + 16,
+		.iv     = "\x1f\x6b\xfb\xd6\x6b\x72\x2f\xc9"
+			  "\xb6\x9f\x8c\x10\xa8\x96\x15\x64",
+		.assoc	= "\xc7\x82\xdc\x4c\x09\x8c\x66\xcb"
+			  "\xd9\xcd\x27\xd8\x25\x68\x2c\x81",
+		.alen	= 16,
+		.ptext	= "This is a 48-byte message (exactly 3 AES blocks)",
+		.plen	= 48,
+		.ctext	= "\xd0\xa0\x2b\x38\x36\x45\x17\x53"
+			  "\xd4\x93\x66\x5d\x33\xf0\xe8\x86"
+			  "\x2d\xea\x54\xcd\xb2\x93\xab\xc7"
+			  "\x50\x69\x39\x27\x67\x72\xf8\xd5"
+			  "\x02\x1c\x19\x21\x6b\xad\x52\x5c"
+			  "\x85\x79\x69\x5d\x83\xba\x26\x84"
+			  "\x68\xb9\x3e\x90\x38\xa0\x88\x01"
+			  "\xe7\xc6\xce\x10\x31\x2f\x9b\x1d"
+			  "\x24\x78\xfb\xbe\x02\xe0\x4f\x40"
+			  "\x10\xbd\xaa\xc6\xa7\x79\xe0\x1a",
+		.clen	= 48 + 32,
+	}, {
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"            /* rta type */
+#endif
+			  "\x00\x00\x00\x10"	/* enc key length */
+			  "\x11\x22\x33\x44\x55\x66\x77\x88"
+			  "\x99\xaa\xbb\xcc\xdd\xee\xff\x11"
+			  "\x22\x33\x44\x55\x66\x77\x88\x99"
+			  "\xaa\xbb\xcc\xdd\xee\xff\x11\x22"
+			  "\x56\xe4\x7a\x38\xc5\x59\x89\x74"
+			  "\xbc\x46\x90\x3d\xba\x29\x03\x49",
+		.klen   = 8 + 32 + 16,
+		.iv     = "\x13\xe5\xf2\xef\x61\x97\x59\x35"
+			  "\x9b\x36\x84\x46\x4e\x63\xd1\x41",
+		.assoc	= "\x8c\xe8\x2e\xef\xbe\xa0\xda\x3c"
+			  "\x44\x69\x9e\xd7\xdb\x51\xb7\xd9",
+		.alen	= 16,
+		.ptext	= "\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7"
+			  "\xa8\xa9\xaa\xab\xac\xad\xae\xaf"
+			  "\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7"
+			  "\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf"
+			  "\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"
+			  "\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf"
+			  "\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7"
+			  "\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf",
+		.plen	= 64,
+		.ctext	= "\xc3\x0e\x32\xff\xed\xc0\x77\x4e"
+			  "\x6a\xff\x6a\xf0\x86\x9f\x71\xaa"
+			  "\x0f\x3a\xf0\x7a\x9a\x31\xa9\xc6"
+			  "\x84\xdb\x20\x7e\xb0\xef\x8e\x4e"
+			  "\x35\x90\x7a\xa6\x32\xc3\xff\xdf"
+			  "\x86\x8b\xb7\xb2\x9d\x3d\x46\xad"
+			  "\x83\xce\x9f\x9a\x10\x2e\xe9\x9d"
+			  "\x49\xa5\x3e\x87\xf4\xc3\xda\x55"
+			  "\x7a\x1b\xd4\x3c\xdb\x17\x95\xe2"
+			  "\xe0\x93\xec\xc9\x9f\xf7\xce\xd8"
+			  "\x3f\x54\xe2\x49\x39\xe3\x71\x25"
+			  "\x2b\x6c\xe9\x5d\xec\xec\x2b\x64",
+		.clen	= 64 + 32,
+	}, {
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"            /* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"            /* rta type */
+#endif
+			  "\x00\x00\x00\x10"	/* enc key length */
+			  "\x11\x22\x33\x44\x55\x66\x77\x88"
+			  "\x99\xaa\xbb\xcc\xdd\xee\xff\x11"
+			  "\x22\x33\x44\x55\x66\x77\x88\x99"
+			  "\xaa\xbb\xcc\xdd\xee\xff\x11\x22"
+			  "\x90\xd3\x82\xb4\x10\xee\xba\x7a"
+			  "\xd9\x38\xc4\x6c\xec\x1a\x82\xbf",
+		.klen   = 8 + 32 + 16,
+		.iv     = "\xe4\x13\xa1\x15\xe9\x6b\xb8\x23"
+			  "\x81\x7a\x94\x29\xab\xfd\xd2\x2c",
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\xe9\x6e\x8c\x08\xab\x46\x57\x63"
+			  "\xfd\x09\x8d\x45\xdd\x3f\xf8\x93",
+		.alen   = 24,
+		.ptext	= "\x08\x00\x0e\xbd\xa7\x0a\x00\x00"
+			  "\x8e\x9c\x08\x3d\xb9\x5b\x07\x00"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f"
+			  "\x20\x21\x22\x23\x24\x25\x26\x27"
+			  "\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f"
+			  "\x30\x31\x32\x33\x34\x35\x36\x37"
+			  "\x01\x02\x03\x04\x05\x06\x07\x08"
+			  "\x09\x0a\x0b\x0c\x0d\x0e\x0e\x01",
+		.plen	= 80,
+		.ctext	= "\xf6\x63\xc2\x5d\x32\x5c\x18\xc6"
+			  "\xa9\x45\x3e\x19\x4e\x12\x08\x49"
+			  "\xa4\x87\x0b\x66\xcc\x6b\x99\x65"
+			  "\x33\x00\x13\xb4\x89\x8d\xc8\x56"
+			  "\xa4\x69\x9e\x52\x3a\x55\xdb\x08"
+			  "\x0b\x59\xec\x3a\x8e\x4b\x7e\x52"
+			  "\x77\x5b\x07\xd1\xdb\x34\xed\x9c"
+			  "\x53\x8a\xb5\x0c\x55\x1b\x87\x4a"
+			  "\xa2\x69\xad\xd0\x47\xad\x2d\x59"
+			  "\x13\xac\x19\xb7\xcf\xba\xd4\xa6"
+			  "\xbb\xd4\x0f\xbe\xa3\x3b\x4c\xb8"
+			  "\x3a\xd2\xe1\x03\x86\xa5\x59\xb7"
+			  "\x73\xc3\x46\x20\x2c\xb1\xef\x68"
+			  "\xbb\x8a\x32\x7e\x12\x8c\x69\xcf",
+		.clen	= 80 + 32,
+       }, {
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"            /* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"            /* rta type */
+#endif
+			  "\x00\x00\x00\x18"	/* enc key length */
+			  "\x11\x22\x33\x44\x55\x66\x77\x88"
+			  "\x99\xaa\xbb\xcc\xdd\xee\xff\x11"
+			  "\x22\x33\x44\x55\x66\x77\x88\x99"
+			  "\xaa\xbb\xcc\xdd\xee\xff\x11\x22"
+			  "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
+			  "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
+			  "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
+		.klen   = 8 + 32 + 24,
+		.iv     = "\x49\xca\x41\xc9\x6b\xbf\x6c\x98"
+			  "\x38\x2f\xa7\x3d\x4d\x80\x49\xb0",
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.alen   = 16,
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.plen	= 64,
+		.ctext	= "\x4f\x02\x1d\xb2\x43\xbc\x63\x3d"
+			  "\x71\x78\x18\x3a\x9f\xa0\x71\xe8"
+			  "\xb4\xd9\xad\xa9\xad\x7d\xed\xf4"
+			  "\xe5\xe7\x38\x76\x3f\x69\x14\x5a"
+			  "\x57\x1b\x24\x20\x12\xfb\x7a\xe0"
+			  "\x7f\xa9\xba\xac\x3d\xf1\x02\xe0"
+			  "\x08\xb0\xe2\x79\x88\x59\x88\x81"
+			  "\xd9\x20\xa9\xe6\x4f\x56\x15\xcd"
+			  "\x2f\xee\x5f\xdb\x66\xfe\x79\x09"
+			  "\x61\x81\x31\xea\x5b\x3d\x8e\xfb"
+			  "\xca\x71\x85\x93\xf7\x85\x55\x8b"
+			  "\x7a\xe4\x94\xca\x8b\xba\x19\x33",
+		.clen	= 64 + 32,
+	}, {
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"            /* rta type */
+#endif
+			  "\x00\x00\x00\x20"	/* enc key length */
+			  "\x11\x22\x33\x44\x55\x66\x77\x88"
+			  "\x99\xaa\xbb\xcc\xdd\xee\xff\x11"
+			  "\x22\x33\x44\x55\x66\x77\x88\x99"
+			  "\xaa\xbb\xcc\xdd\xee\xff\x11\x22"
+			  "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
+			  "\x2b\x73\xae\xf0\x85\x7d\x77\x81"
+			  "\x1f\x35\x2c\x07\x3b\x61\x08\xd7"
+			  "\x2d\x98\x10\xa3\x09\x14\xdf\xf4",
+		.klen   = 8 + 32 + 32,
+		.iv     = "\xdf\xab\xf2\x7c\xdc\xe0\x33\x4c"
+			  "\xf9\x75\xaf\xf9\x2f\x60\x3a\x9b",
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.alen   = 16,
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.plen	= 64,
+		.ctext	= "\xf5\x8c\x4c\x04\xd6\xe5\xf1\xba"
+			  "\x77\x9e\xab\xfb\x5f\x7b\xfb\xd6"
+			  "\x9c\xfc\x4e\x96\x7e\xdb\x80\x8d"
+			  "\x67\x9f\x77\x7b\xc6\x70\x2c\x7d"
+			  "\x39\xf2\x33\x69\xa9\xd9\xba\xcf"
+			  "\xa5\x30\xe2\x63\x04\x23\x14\x61"
+			  "\xb2\xeb\x05\xe2\xc3\x9b\xe9\xfc"
+			  "\xda\x6c\x19\x07\x8c\x6a\x9d\x1b"
+			  "\x24\x29\xed\xc2\x31\x49\xdb\xb1"
+			  "\x8f\x74\xbd\x17\x92\x03\xbe\x8f"
+			  "\xf3\x61\xde\x1c\xe9\xdb\xcd\xd0"
+			  "\xcc\xce\xe9\x85\x57\xcf\x6f\x5f",
+		.clen	= 64 + 32,
+	},
+};
+
 #endif	/* _CRYPTO_TESTMGR_H */
-- 
2.17.1

