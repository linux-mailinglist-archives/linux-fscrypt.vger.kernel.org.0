Return-Path: <linux-fscrypt+bounces-962-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C5773C5B773
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 07:06:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6B25034FE8E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 06:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC2A2DCF57;
	Fri, 14 Nov 2025 06:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="KXYUukLq"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E54E2DC795
	for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 06:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763100149; cv=none; b=XZ8Z+dtZic+vHRvGDdm/B04jgth0hcvMWm3z0/NekqsWLmiWeD4Txj+ta5KdfTpOBDeA9lDQRfmXhw0aofbocb/hnTEVsO08L4LHyfDuht5VXYuGPYtulZlI38hkiooenEx3q3y9YkwmTO4f/eKn5cg7sEFoYYZEJeTU/hxaKG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763100149; c=relaxed/simple;
	bh=I6hn5XyUpnrWRuQcjJdlpYH7Q9/3VAy8I4U1WzKLW0k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GiL0WU74AWl4ZzjJky43dD2VmC+gNgJF+PIK2J/Cs5iVTDMLKfCslI3+RINDsuifWOBxzGv5diXfBncIjL0cePGcZ/UzC6XFcqJe/RQLf4MKmRhIV0gv0RmVeDB7AkG0sS3b5Ujaes/lQrmaWvNjVFKuyRjXvWcaz9TQSObFnyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=KXYUukLq; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-297e982506fso18113775ad.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 13 Nov 2025 22:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763100147; x=1763704947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ERv4XtgoXPP2dPnpwcSEeS4AUqPV+CdFVlWhf34t39A=;
        b=KXYUukLqInLfvVAR8TiBnG8x2Q85rxVFmReEBqT7PAsEV3RUlxmViDSpKUJG30Pc+B
         jwnbGcunncfo82I3xk5tbH6J6PwbPZ09pydzcfB2peyKakQ+NYv1ffuZbPLThVYxRGFB
         2W3y2OUIqngzCaNjsxzEwJsFkN/WCelB7f0dJQVoLJuL5B9zuxOCTCE0zV5lCLq+I+v8
         8VcYP6HAszg8US8rz4QI1tAnYjMybTDBM0SRF6l7tTKvCEPIjVT/jVmIlSR31bk9Mqn4
         tcsfB69z3x/+Yp77fKmUJHsAkaamPsIeviNtT05YMFx5+8Q30p4q9y3dsngWQKPxnJ5H
         22Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763100147; x=1763704947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ERv4XtgoXPP2dPnpwcSEeS4AUqPV+CdFVlWhf34t39A=;
        b=b2XkXApZQvueQV/HIsMFS4mssG64hmuH1hB0fkfhWpj0bXTfghYT4oz/Uv+xCp7/Oj
         gXevUDZS+dZw2G3VaLtEH+KxgFr3KYplZaK6OM19kFRqW5/5gNy4G+cnUrDiFBTDGcB0
         1/DNQCxgX9gtAtlDzzXvnStFFVXE1tqihlbbAFFAvXeuBqL1NWmNZWFLnGxmu+pCWM9q
         pqfb+On36dyAG1t3DT+uajFeMZwXrvLPwq6TI1hhIn4Wwza43Zw0YVCFbZ02S7Pkx3tn
         TAGQIFh4aRNySBqI8PAZQzbnO7tQ0XBXsT/tHLZZM4BuxSzoGt3z0kW9fEbDZr7q5q6y
         pfWw==
X-Forwarded-Encrypted: i=1; AJvYcCXvzE/MLu76wKA06CUpMpiqdxpzuxILFlBprgXV3pGG+qYxlbb+cadPjNtXahZ8mM18e4kD4ei3Kna/pMpb@vger.kernel.org
X-Gm-Message-State: AOJu0YzBi0N62z5F4H5fyYnk718UjJ7fGmHV9GxbcH6wFAtfuub9VHFC
	ssAR0pwSUeLkafiizuQVqaxZlZFW+TPJIhgICbBnwczLolSnJGzenGJEgVlngvSCmcc=
X-Gm-Gg: ASbGncvyUnF9fHaF8y+8yXm5423PKJkhQTF+7GxMmuJ+9oZTBYBcDDsEt+s2FaPcPut
	UvQPqF5NnNWCWLADSHUjBEkrrDwPnniNFfjOjyNY6+7dEB/oCO8gao3aPR1SFJh6UQ0RHGECZfw
	zlyjp27LGURtCNAVo7HSXoabdt2bOGSrlA4/cSTR+Z2B5zkhyOB3wnowvwkpqjmIySur/JbblAb
	+znFwb5z54CiMNF6xYWiSaRz1BGTHLwf2CfghR+qjpgsfGi2wEE0WsVfq2EssSWgs9/BxFMAgLn
	ojnfhxYVGzOySrWzsOT6v3+OfKMrKjzkiGu2N83WP/m4MOdqg/S5Pde40qO3om1/P4n8lMlrZAQ
	RGJ/2akPzyys1M+6/6gFtxiyxJ4oyrmXfELoyXlBYSYr5VL8S9qzCSue0m4ed7YOAbttN90eI3E
	nTnrHFVCNtmXKKMgcOaMbjaVKq
X-Google-Smtp-Source: AGHT+IFs317cxuw2DDSKPoB1op+RLqXuzE2pstLiig2tLA8KeXhRrXBdYzwc2MB74Tur9nS/jMyR0Q==
X-Received: by 2002:a17:902:cf08:b0:265:47:a7bd with SMTP id d9443c01a7336-2986a6bcff3mr20918665ad.4.1763100146747;
        Thu, 13 Nov 2025 22:02:26 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:22d2:323c:497d:adbd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2bf17dsm42818665ad.94.2025.11.13.22.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 22:02:26 -0800 (PST)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: 409411716@gms.tku.edu.tw
Cc: akpm@linux-foundation.org,
	andriy.shevchenko@intel.com,
	axboe@kernel.dk,
	ceph-devel@vger.kernel.org,
	david.laight.linux@gmail.com,
	ebiggers@kernel.org,
	hch@lst.de,
	home7438072@gmail.com,
	idryomov@gmail.com,
	jaegeuk@kernel.org,
	kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	sagi@grimberg.me,
	tytso@mit.edu,
	visitorckw@gmail.com,
	xiubli@redhat.com
Subject: [PATCH v5 5/6] fscrypt: replace local base64url helpers with lib/base64
Date: Fri, 14 Nov 2025 14:02:21 +0800
Message-Id: <20251114060221.89734-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the base64url encoding and decoding functions in fscrypt with the
generic base64_encode() and base64_decode() helpers from lib/base64.

This removes the custom implementation in fscrypt, reduces code
duplication, and relies on the shared Base64 implementation in lib.
The helpers preserve RFC 4648-compliant URL-safe Base64 encoding without
padding, so there are no functional changes.

This change also improves performance: encoding is about 2.7x faster and
decoding achieves 43-52x speedups compared to the previous implementation.

Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 fs/crypto/fname.c | 89 ++++-------------------------------------------
 1 file changed, 6 insertions(+), 83 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 8e4c213d418b..a9a4432d12ba 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -16,6 +16,7 @@
 #include <linux/export.h>
 #include <linux/namei.h>
 #include <linux/scatterlist.h>
+#include <linux/base64.h>
 
 #include "fscrypt_private.h"
 
@@ -71,7 +72,7 @@ struct fscrypt_nokey_name {
 
 /* Encoded size of max-size no-key name */
 #define FSCRYPT_NOKEY_NAME_MAX_ENCODED \
-		FSCRYPT_BASE64URL_CHARS(FSCRYPT_NOKEY_NAME_MAX)
+		BASE64_CHARS(FSCRYPT_NOKEY_NAME_MAX)
 
 static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
 {
@@ -162,84 +163,6 @@ static int fname_decrypt(const struct inode *inode,
 	return 0;
 }
 
-static const char base64url_table[65] =
-	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
-
-#define FSCRYPT_BASE64URL_CHARS(nbytes)	DIV_ROUND_UP((nbytes) * 4, 3)
-
-/**
- * fscrypt_base64url_encode() - base64url-encode some binary data
- * @src: the binary data to encode
- * @srclen: the length of @src in bytes
- * @dst: (output) the base64url-encoded string.  Not NUL-terminated.
- *
- * Encodes data using base64url encoding, i.e. the "Base 64 Encoding with URL
- * and Filename Safe Alphabet" specified by RFC 4648.  '='-padding isn't used,
- * as it's unneeded and not required by the RFC.  base64url is used instead of
- * base64 to avoid the '/' character, which isn't allowed in filenames.
- *
- * Return: the length of the resulting base64url-encoded string in bytes.
- *	   This will be equal to FSCRYPT_BASE64URL_CHARS(srclen).
- */
-static int fscrypt_base64url_encode(const u8 *src, int srclen, char *dst)
-{
-	u32 ac = 0;
-	int bits = 0;
-	int i;
-	char *cp = dst;
-
-	for (i = 0; i < srclen; i++) {
-		ac = (ac << 8) | src[i];
-		bits += 8;
-		do {
-			bits -= 6;
-			*cp++ = base64url_table[(ac >> bits) & 0x3f];
-		} while (bits >= 6);
-	}
-	if (bits)
-		*cp++ = base64url_table[(ac << (6 - bits)) & 0x3f];
-	return cp - dst;
-}
-
-/**
- * fscrypt_base64url_decode() - base64url-decode a string
- * @src: the string to decode.  Doesn't need to be NUL-terminated.
- * @srclen: the length of @src in bytes
- * @dst: (output) the decoded binary data
- *
- * Decodes a string using base64url encoding, i.e. the "Base 64 Encoding with
- * URL and Filename Safe Alphabet" specified by RFC 4648.  '='-padding isn't
- * accepted, nor are non-encoding characters such as whitespace.
- *
- * This implementation hasn't been optimized for performance.
- *
- * Return: the length of the resulting decoded binary data in bytes,
- *	   or -1 if the string isn't a valid base64url string.
- */
-static int fscrypt_base64url_decode(const char *src, int srclen, u8 *dst)
-{
-	u32 ac = 0;
-	int bits = 0;
-	int i;
-	u8 *bp = dst;
-
-	for (i = 0; i < srclen; i++) {
-		const char *p = strchr(base64url_table, src[i]);
-
-		if (p == NULL || src[i] == 0)
-			return -1;
-		ac = (ac << 6) | (p - base64url_table);
-		bits += 6;
-		if (bits >= 8) {
-			bits -= 8;
-			*bp++ = (u8)(ac >> bits);
-		}
-	}
-	if (ac & ((1 << bits) - 1))
-		return -1;
-	return bp - dst;
-}
-
 bool __fscrypt_fname_encrypted_size(const union fscrypt_policy *policy,
 				    u32 orig_len, u32 max_len,
 				    u32 *encrypted_len_ret)
@@ -387,8 +310,8 @@ int fscrypt_fname_disk_to_usr(const struct inode *inode,
 		       nokey_name.sha256);
 		size = FSCRYPT_NOKEY_NAME_MAX;
 	}
-	oname->len = fscrypt_base64url_encode((const u8 *)&nokey_name, size,
-					      oname->name);
+	oname->len = base64_encode((const u8 *)&nokey_name, size,
+				   oname->name, false, BASE64_URLSAFE);
 	return 0;
 }
 EXPORT_SYMBOL(fscrypt_fname_disk_to_usr);
@@ -467,8 +390,8 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 	if (fname->crypto_buf.name == NULL)
 		return -ENOMEM;
 
-	ret = fscrypt_base64url_decode(iname->name, iname->len,
-				       fname->crypto_buf.name);
+	ret = base64_decode(iname->name, iname->len,
+			    fname->crypto_buf.name, false, BASE64_URLSAFE);
 	if (ret < (int)offsetof(struct fscrypt_nokey_name, bytes[1]) ||
 	    (ret > offsetof(struct fscrypt_nokey_name, sha256) &&
 	     ret != FSCRYPT_NOKEY_NAME_MAX)) {
-- 
2.34.1


