Return-Path: <linux-fscrypt+bounces-847-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D405EBA2971
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Sep 2025 08:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61A6F1B280D0
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Sep 2025 06:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BDA27EFE3;
	Fri, 26 Sep 2025 06:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="X1aLK2eW"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216E827E040
	for <linux-fscrypt@vger.kernel.org>; Fri, 26 Sep 2025 06:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758869825; cv=none; b=iLev7E/nYlHnHg59eyqU4KVZG1Txh+MWGPg+O8eM7KwyNHPycYJ3TfHR/lrQmkF532+SaER45LxA+CldKsab4c35+OtRDfclXBFAmzzMFq8JFoD7Litcq0zopzih9KIV9uFbcscLix4fXsUFnOR+pFlf3Ztt6yEhM5ugzMEOGAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758869825; c=relaxed/simple;
	bh=OGjdQW2fPGuYQ5EHej/4NhFa8z1IHIEgYJSvEvOJ/h4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NloLn2pHeP/oFPy7XO88ulhkmYafLoo6ALhpEgn9jyFvYVH0JxRIiGQEqWCz2JEliRdbAlbKn8TaeVnuZJLY5HpdZ1WdptNmBAD5RN9XJXBLDBfSS9JvaQMeaqhase1o2Pqc39HQRKw9u502w+CA+prpUt5fwqvWNFaW/bQb6UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=X1aLK2eW; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so2005947b3a.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 25 Sep 2025 23:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1758869822; x=1759474622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QX1AvjPYqPc07VyrXJLPNqN7Y76elCWsekCNrFr22Ew=;
        b=X1aLK2eWhl4PdjusXxGMjAFblRu51kKwaiLrZONuDCLo4V9OwHbVAEKHfbvJfT6N+Q
         AEzEI5VwGxMAwrlegVYHI3P9D9cciOJxwiU7bX+9X4NRR4xKWa6xm+FPGQtk9zKxtGB/
         XMYWvjv+9P9ckSu3ZmMpI33pQFz0LY71UJZu+iWo9pqtK6HIn6lYpIUrld5A/RwtYvQU
         bVk7daTOZaDCQRHYLX4kC6zDDI63e0Tb74Rw5aV4DCJhG09ynfbQaLNb+HETHx2JgPrk
         Hl5MpSe5jRKRcDnhOfZlHOypf15fWdxZfF+f+p4u4l9Ij1sz9UzNl1GRzZ9/OYXjb2MS
         Ja7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758869822; x=1759474622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QX1AvjPYqPc07VyrXJLPNqN7Y76elCWsekCNrFr22Ew=;
        b=W19OEwSvsHOWgMxEgFMYlh44HlUtgx9FBLvYXs8UUhFRnDfwZ9Zpbln+LZRJ1E5TKF
         dxvnyNgCAs6Yq9EDZmekYJSP+8yk80VEy09v+aW3J6opPF/2GJCgkG1KSGZwUJEwJPTe
         6JwAxZMOhmyJEIz9oPcll6BlU5tI1JVB48TXeAHnB/G4Iz4eEJOBOdmTFD+9ptr9mFQh
         uHC/Ok63pwbO4jIyBAcSgTvCKvacehIohKQ/0xnxqJZSA0qi2T91nIGaZ1tNM/LiVszV
         xPPk4PKk6f3zU76HmpUbjQjk2k82qPes7Mt/iPLaxRh5ksL1kQy6pxO17L/5U28l5cfD
         JAYg==
X-Forwarded-Encrypted: i=1; AJvYcCWlJzJK1bdj+4jiWXWIpeUHIvwNRlJ07yBunqWegKeNnFKnyyPuD93N97X6RYxDvqaQOKwB2U5Rd16TgpLI@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4+x5cuiETx5kac2uPfG7tV6lIw7+n0B+MIKN0Sns7mRkkPeE8
	BBzoKFYEkEvBflgx2pXCqadMYdYPmZhZ/nddae0gtF/gwzELYHc983kZuxuY7gWpODI=
X-Gm-Gg: ASbGncsaDeX3VqaBXzdtMFQopFusELANtZ3jKvVpuPz1bEeM5H91zARXz3HJRNWW8Eo
	etUu1GE0ZL25ibmLgnaJvUGjor43BCKfDdb8CR5R8qDDfZGmeFfoos9m2X7dngJ3F62NSt3UpCq
	ROeehOWGMrrEHgXZUNYoOtdiwcwhcYPsy7z8jw6TgN/80SFmVDOG9aW3aMQOwhqOWH84HN88H8V
	24fOm1SkxajP4Bm56MvKjycyqwjOUI5G2R2y0UGef2t482Y30ocFiCe7JfJAoS/X1G1fIw4WSF+
	QT8Ia6BnKXEv5B7w4oQqU4xs7tpcybZsXLeYA2D9BiuZupEV9W331OZRsaI6kr+0CmgC1cjkLKQ
	HldGnQaJjnqtdlyUgJbw5XCRnAqIAdGWeBcqtfjsWLKQdMYevENYbFj2hCA==
X-Google-Smtp-Source: AGHT+IEJuoFu3AqWz+6Ia84gW9VhTEjnQyT1iUNvqk+U9XhDT4f46dcSlDiMFRq3zQJq5LoCWNwKLA==
X-Received: by 2002:a05:6a00:853:b0:772:3ea3:3218 with SMTP id d2e1a72fcca58-780fcec0a66mr5554818b3a.23.1758869822399;
        Thu, 25 Sep 2025 23:57:02 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:94ad:363a:4161:464c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-781023c158fsm3654182b3a.24.2025.09.25.23.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 23:57:01 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: 409411716@gms.tku.edu.tw
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	ceph-devel@vger.kernel.org,
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
Subject: [PATCH v3 5/6] fscrypt: replace local base64url helpers with lib/base64
Date: Fri, 26 Sep 2025 14:56:56 +0800
Message-Id: <20250926065656.14522-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
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
decoding achieves 23-28x speedups compared to the previous implementation.

Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 fs/crypto/fname.c | 89 ++++-------------------------------------------
 1 file changed, 6 insertions(+), 83 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index f9f6713e1..dcf7cff70 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -17,6 +17,7 @@
 #include <linux/export.h>
 #include <linux/namei.h>
 #include <linux/scatterlist.h>
+#include <linux/base64.h>
 
 #include "fscrypt_private.h"
 
@@ -72,7 +73,7 @@ struct fscrypt_nokey_name {
 
 /* Encoded size of max-size no-key name */
 #define FSCRYPT_NOKEY_NAME_MAX_ENCODED \
-		FSCRYPT_BASE64URL_CHARS(FSCRYPT_NOKEY_NAME_MAX)
+		BASE64_CHARS(FSCRYPT_NOKEY_NAME_MAX)
 
 static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
 {
@@ -163,84 +164,6 @@ static int fname_decrypt(const struct inode *inode,
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


