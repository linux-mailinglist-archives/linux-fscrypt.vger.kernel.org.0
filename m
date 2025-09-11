Return-Path: <linux-fscrypt+bounces-817-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8C42B52A66
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 09:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2C5B483C93
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 07:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E4429B200;
	Thu, 11 Sep 2025 07:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="g10tbuW9"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C9529AAEA
	for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 07:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757576764; cv=none; b=VNLhpNees59DkRll+CBCsqo1nNosU0VAtZldJvM833Jr8CDvmTHandeYggp+GQIDZf5X58xWCrUdppSZKfopUeH/2M+65F0U6YqbULDRb7KVzESzcbsDtuqkmnrkR+0yUjKWYau+usEuCHIJiumdKChbOIQm00x0mW9Nmv0jXlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757576764; c=relaxed/simple;
	bh=O71eOxXN8qtxCpJO9bMs63EIF1c0j2xDoLcNf4kljL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J+nizy9e1KyhQc+ZCzgxJlMm5qL7YGTZ0RTXDCkuMgCyJOjPpoCYoY1hucInVMRdTAhlSDp3vwB18cWspQc0+3GUzaIEulHA4bpcqs9jA6P0YuPXy+zwbnOKqn0RGjLEtgKKBazCS+xBjqe2QuzXHUmb4HV2Xpu9melsWrZ+zjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=g10tbuW9; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-772481b2329so520619b3a.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 00:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757576762; x=1758181562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9sqCK5RjxgMvTS/KMSGZswVuHs/rB1hx6QH50USYYeg=;
        b=g10tbuW9C+sdkHbwh7urrPDyrm5TOiaVt9kYOHfwfutBNr6w2JLnzInh++vN6KghRk
         FEdfY3vqOOEPP30LZ3/g587DNZn2zUSYZEOJZnCwIThETSvDuE86uJp/cO2I+L3yuoxt
         EEBlJRDONMCnbcIFEC8CGztF4y8eCYKCOYKfRadPxNcUDffbQmSv8jms6l5MAS792DnJ
         9ww1QfZlWdbxOkipCyfSEErOoiMjPWHSRcRUyou3nmlTykSJ096iyXHynBNVKX7vquW+
         8gE47TMqsVrGR1eWBTSHtrrR02bIX8KWrsQ2i3zBRrho0/ibU+m3rfjQq+QH8KZLKE2K
         rhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757576762; x=1758181562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9sqCK5RjxgMvTS/KMSGZswVuHs/rB1hx6QH50USYYeg=;
        b=anjkw6TkW6hfsVm+Vb/fncLXbvFabI3piZCFIx7dFpgTrTOJmHB38+T3e8fzoXcEAf
         /C6XB/4vZnxhkOMtSTboVlXqo9PdjyytxE/gVFLlxpT7F6lYTaPGPdLK+f7yDFLRk4L3
         5Q1tdu7RkQI4owCmNkJAuE3upbv57Y+ZKIFB8voXhAUUNDARrZpb+UCU7d/nN9oqjOIC
         /B0zRB4fURarF3Cj353e2cn6gfGXrWlAQpV60/7dd837pdypJjNtS2h67PtbgAlRowyG
         0e0iFdzm9AdJgsLyNB/RWJ2r0x3V7YPW0Pwyh2t+XQ8nSU5IF7pv8tchgFu/mOMkO3mP
         5pMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfMZP17TZXrhh1peEq9bkVMf4dawWSV0M9nrIcT17eq3u5clscQAkpplQWqQnaoeC4GECF3KMCcXPeGV/R@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8xF6iN1Uyg02nU1LVsu/5MwnilSTnXcmkkR71fs/RAvCTa6/q
	BFxdRL+1V85y9nZtrW06Y988h8Ra21K1vbCFMi7MtKuqBl07hQGl8E6Ozqk9Jm4IMOA=
X-Gm-Gg: ASbGncsRvDmdEpE2O6xgS7Wn13VuLm9geV5HGLRirySqB24rrBK7+zqfZIyTNHBIAhr
	6nUTa+LE+DX3lqJE4HQO0EXOenSUESpVw6i/2L9PEqnvEUmzOgEmqgxLk6MFDRrhHnYgkKQhpKU
	XujrNsdXf2bQ7d0FVG6RgXxOfMmq6EuRSoEXNyYVcRjY/VqmHN6XkgN00uQoYV1t4Ce5xIeZcmx
	QadBHJCitVEPzz7HIFtV0rL0E64H9hJi2iyQ6KWft33D07Ir2E7HIWMqHYiKNsAZjZLpkX2t9tX
	Nc+exZ+5/xOEfQg0pmm5nIpZg58BrgaEGsRpJA4ffJqJNt5Cn9l6mD7AreaQTHROia2dHFE3YwU
	3ZlwZvl/DfuGDoC6baX+ocKSSFLFbL47Wed/Ns18HM12CTdCahiOMdZ+osBWWhzubU89k
X-Google-Smtp-Source: AGHT+IFTtCHwqNfIBOXwlFvy/P0nkEKjAL4uI3LrM5NYhtuUi4RxaoEj1xk7ImpRtf5RyJZJwkkNeg==
X-Received: by 2002:a05:6a00:1a8f:b0:772:2850:783d with SMTP id d2e1a72fcca58-7742dedf06emr24743666b3a.22.1757576762510;
        Thu, 11 Sep 2025 00:46:02 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:7811:c085:c184:85be])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607b18424sm1134273b3a.63.2025.09.11.00.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 00:46:01 -0700 (PDT)
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
Subject: [PATCH v2 4/5] fscrypt: replace local base64url helpers with generic lib/base64 helpers
Date: Thu, 11 Sep 2025 15:45:56 +0800
Message-Id: <20250911074556.691401-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
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


