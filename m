Return-Path: <linux-fscrypt+bounces-813-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9715AB52A0C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 09:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52465A03656
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 07:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F090C26CE39;
	Thu, 11 Sep 2025 07:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="gDSXQxMs"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1551F9A89
	for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 07:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757575984; cv=none; b=MR6t6kuf+t78Epm+Xz5hOX7woUPqxK5Q9qKh2wQta3kqp28cikW/cZKJsQ5dDD3YjznDzgnQ+YivycXonA7GZsvjU6KgMahcSEmm/uoRYRNbODUFyM4TM7fJl+mPogeGDR9xX/jBNyVHsOU+0O0vrFlgt82p7GegENrJ7Pflt4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757575984; c=relaxed/simple;
	bh=O71eOxXN8qtxCpJO9bMs63EIF1c0j2xDoLcNf4kljL0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t6o3NntOYZcPg/F/BakxZiQX88f6NCck5qLfD05CmYqHtyjV9nGWyWd4i0PxZ1wLu42TQIkncl7XWC9m1WhFyugojGX3a1UmjO3aHISrUQx3bwwcKSyDqE+qh9V04HHtvSw31q9ze+KWeqBiX4p1kGoTDDHGPKBrUVIaUcy62W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=gDSXQxMs; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-24eb713b2dfso3371415ad.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 00:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757575982; x=1758180782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9sqCK5RjxgMvTS/KMSGZswVuHs/rB1hx6QH50USYYeg=;
        b=gDSXQxMsH9WpLyEM3F3kt4ql5XFmQB8s70SlrWReKCwQTji0Dk8VpxSbclbZBLb8bv
         Wo+TCZDkzToDbfrscFQYZz4t8M+sSAVD+6Cr1yyFUHWG4deufIZ2CLeJ5ha0V0ANpSgp
         n0wEVc4MP5BqCmnFSjCyyGPdhlTO6HVUG2uW2tEf+THq4GpeKi+BG+N2tbthARLJ9AqW
         nn82isQlnlbNYEj9+eYG7252PgJ5jzlbSy7icT55Gyfcd8QwJN7ctkq4iKA0mwHlpSr1
         6ki7FpLnPzdYTTMpSGXPMZB5eGxYgglwl4znOwvt2UCN10jW6ztjFINejq8/SEkpy/1i
         ipaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757575982; x=1758180782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9sqCK5RjxgMvTS/KMSGZswVuHs/rB1hx6QH50USYYeg=;
        b=wveXOS4mCIpMeI6CzDYLpbMbheASsyEtjthQke5lAX97hlV0Hp8VvIcmoXQd+SpqZ7
         qQKNH7ez7TrPhSXB+INGSQHmGJ/pNQ8ABmxX2LavADQQ6NKg6KCKYnhgn2oH+Yt9Xt9+
         O9qsj+eylxXwjLYgWOskBKEzFcK0PS3A/VypQ39zCvwrOUuUtvcdBTkAPf9xLVRkRGcE
         O8U3VPuRhOuPmHp3YIjZt6rAqTaYZIzxUWiBPfcevyMpzdNm4j1aBZkIinqMFY61nXqB
         KuXzDMJUcj/hFDP9pDdDGBu84o0Nd8bvD52ghgLcG4e8a7zstj6/DtWKzXVBzVmZbr+m
         yVTg==
X-Forwarded-Encrypted: i=1; AJvYcCUTkOyY9K3fknNlsVk/WpMYGrevaqs9WZt6UaIl2ZjpwPwM0Wfx64N+sEYLv1wSYsEdhtCj7fx/wzvc+pS/@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8sVNZNrCajqfXJO0S/YgNfxv3yKEA29zCbOx0qZAOKphxtD8c
	ePGmPWX7QrRVrGA/TwIzm0i+o7OVbQ9NtY+YnXgypF1VjbKTxp9kgXASexUcCvaBcQw=
X-Gm-Gg: ASbGnctkaMVVXB95ETBe21HUAZ7wA6jBhGJLiktYs+ewcMLdXRe1/mbsCvj9felkanx
	kvNntAP+J8wVrUWJwz6NqHsoh5fSaUovjM99oGSOBTKwU6hvwGrI97wNsy3H4Ar0dJ6YPpS5OXp
	6nn6SQtaCHsSPNeNYHaWI9AQBo4y1E6xpIArjrrlvKsrSeH9emZEdR6tmq7wxGL1SQtfCMnWNI6
	bZgTzLuWbOUl+sCM7PkfJXk8lZLWglm//hIoawblEU5JQpyS6SzB0b7swhBYeONczMwxlPucCrX
	1i91nd42jReYyl+gCoilly8QrVPf3GgSwiEtojhCRXte+g0HsbDB48N/yyjcjdS2U0ec15OBUCl
	slRc24bf3kIWeCKBcQXad7sx2W16NNiyPEM0cGfYNU0Qu3zFgUAZU/fb+kQ==
X-Google-Smtp-Source: AGHT+IFD9aePnHBtB13DZnlZ8Ibfo6GnzucKKeZU8KCH9/Ow9xL5SQ7qcnFeRVs1LbSv8OFB76dPGQ==
X-Received: by 2002:a17:902:d511:b0:250:643e:c947 with SMTP id d9443c01a7336-251715f34e4mr234231735ad.28.1757575982336;
        Thu, 11 Sep 2025 00:33:02 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:7811:c085:c184:85be])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c36cc6c2csm9959415ad.11.2025.09.11.00.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 00:33:01 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me,
	xiubli@redhat.com,
	idryomov@gmail.com,
	ebiggers@kernel.org,
	tytso@mit.edu,
	jaegeuk@kernel.org,
	akpm@linux-foundation.org
Cc: visitorckw@gmail.com,
	home7438072@gmail.com,
	409411716@gms.tku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	ceph-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 4/5] fscrypt: replace local base64url helpers with generic lib/base64 helpers
Date: Thu, 11 Sep 2025 15:32:54 +0800
Message-Id: <20250911073254.581898-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the existing local base64url encoding and decoding functions in
fscrypt with the generic base64_encode_custom and base64_decode_custom
helpers from the kernel's lib/base64 library.

This removes custom implementations in fscrypt, reduces code duplication,
and leverages the well-maintained, standard base64 code within the kernel.

The new helpers preserve RFC 4648-compliant URL-safe Base64 encoding
without padding behavior, ensuring no functional changes.

At the same time, they also deliver significant performance gains: with the
optimized encoder and decoder, encoding runs about 2.7x faster and decoding
achieves 12-15x improvements over the previous implementation.

This improves maintainability and aligns fscrypt with other kernel
components using the generic base64 helpers.

Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 fs/crypto/fname.c | 86 ++++-------------------------------------------
 1 file changed, 6 insertions(+), 80 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index f9f6713e1..38be85cd5 100644
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
@@ -166,81 +167,6 @@ static int fname_decrypt(const struct inode *inode,
 static const char base64url_table[65] =
 	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
 
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
@@ -387,8 +313,8 @@ int fscrypt_fname_disk_to_usr(const struct inode *inode,
 		       nokey_name.sha256);
 		size = FSCRYPT_NOKEY_NAME_MAX;
 	}
-	oname->len = fscrypt_base64url_encode((const u8 *)&nokey_name, size,
-					      oname->name);
+	oname->len = base64_encode((const u8 *)&nokey_name, size,
+				   oname->name, false, base64url_table);
 	return 0;
 }
 EXPORT_SYMBOL(fscrypt_fname_disk_to_usr);
@@ -467,8 +393,8 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 	if (fname->crypto_buf.name == NULL)
 		return -ENOMEM;
 
-	ret = fscrypt_base64url_decode(iname->name, iname->len,
-				       fname->crypto_buf.name);
+	ret = base64_decode(iname->name, iname->len,
+			    fname->crypto_buf.name, false, base64url_table);
 	if (ret < (int)offsetof(struct fscrypt_nokey_name, bytes[1]) ||
 	    (ret > offsetof(struct fscrypt_nokey_name, sha256) &&
 	     ret != FSCRYPT_NOKEY_NAME_MAX)) {
-- 
2.34.1


