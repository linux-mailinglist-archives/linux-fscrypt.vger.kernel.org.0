Return-Path: <linux-fscrypt+bounces-963-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E16C5B78B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 07:07:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 61C14358681
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 06:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D33312DF15C;
	Fri, 14 Nov 2025 06:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="ZFGM+JFR"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10A32DF130
	for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 06:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763100171; cv=none; b=sCyp/wy5qtNvbgyuMQNBiNgW9/ddpfFoTBna8izjfLhnnB9LjpODlO4o5od5VxDovq2eHAXz3/N7j4aIatdAF18OWmLGrrDsMQHYuNWc1cJ7QzIPqS+vl+X9ZisYrkkgoQBEkRpy3nKYHQEZM7Zib+sc88rxQ2T8/6h48O8henQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763100171; c=relaxed/simple;
	bh=gDlG7kblX5YeTHlzPrAqnEVGCYQCrx9weplGIGbrDpA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ucsSsmIHfBUQA7NySJu/W7LF+wyFRkIAOqK+WkwRXe/FoTbfZhdP5l1Bt6DjWLIW8hc/cswxclJAyT1iyiL1JLC1XiO2o+jc4CowZu6TUqwR5W8+gYdN7RKZqVFHWen/u6/41Yev80FETJamiw0XACPFnXs/Yb+0E48KOTjB7c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=ZFGM+JFR; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b9a98b751eso952997b3a.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 13 Nov 2025 22:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763100168; x=1763704968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3VNVy+UYeqY3IVTtkh/AbSvZ3E8GHu4GINXGK2iL3Y=;
        b=ZFGM+JFRrpC2719pwW9w3/ChjvaR2tTMKgsVK1oUWlePszG4GrKOiWk4H6P550LKI+
         DVgEquE55pjrW/0WvmBeCsojIMDM579HC3DUxxr4lr1i+90jIcFC6hosyEv5UtoacMXj
         i2Xr0IZPS1DlN0KGWj0Rx6cH603C31FKKw9kBlH28bID43dBfVX4Ra5W0D2kD7dDaDUI
         9CmLM44Tb/5+7ES85BTSXL5AWcKJtxDkDfn6Xj4ISpsnHDLpI8eTwUShWX+gCevZt//0
         SagegkvypNQ4tWRpD7SOzLU1cCijbVanaP0sd97xQQy11RTV7dMUnu2pWwbgcOHWrLU+
         zgjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763100168; x=1763704968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y3VNVy+UYeqY3IVTtkh/AbSvZ3E8GHu4GINXGK2iL3Y=;
        b=DdEQ2BYBKo5Uxzc3trSCmY2954yBH7/ONAB2rVGmSXbV0Kwglf/NESHaqUTzudVNRR
         OZz+WqLMoMl0pV2qwnPt/u9iP0ZGXBlzrm75ef07V0JHX9JPBS0zcq69QJhRRUR95YUY
         +ZsemmhYcMto75ksmvd35m9n8Fm0eCy0wQ88s6yxc4DmVHTYdvWGQ+SjHT7Kvl2ICCm3
         MwbmAOY1PIc4G7TajVOZarpgo20NYa8X7Rs2WlJ+/mpsS5L0orwGWtHAU685paoeyDc6
         yx+pajnbhq6PDrOKFr8QcEb/H4HlNEthUtVrX4/fcI1EBdwZnXLf/Huo3dODGeFd2dGU
         31Ng==
X-Forwarded-Encrypted: i=1; AJvYcCUEpRfBvW7x9cCzlC4NqswlWpPjUD78oWoIO1jhcOL4ronkK0PpCwHNiGs403TFEq09ZsDRMzn0g0H1QnVY@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1el3fy2/qiqaXrQQUv84qevytnHdoVFzApXLdduTfuigaBMkX
	Fxzr7wwBAVtKwtRVrrXiUM3vFKETgYLW7AJkG8W9UE8XEgh8weMPF8fHJ4zHeR+rOgw=
X-Gm-Gg: ASbGncv2/rjY2kVaPk4381O7JcMVH+CtMQz1jYfg8Ts1qr9YswdNPigeuBLEvBMvggM
	1h91IUJLdzAtlQ7fFh/8K8nESYkcd+nJHrL2KpMXIMTI2jtrgceM/Ulzw1ULNAA1Chs6uZD8WtY
	0zXY/6kH2GFSCb+24wM0vkydwmFZ9syuuL3fbmi1V5cIF57j+pWB3dx6vkbNow/o65puaEQO+YF
	Lk6NQih+TfKWkuKkNFAG28ejCFAEG2xHLO2KRu63YAED+HVYPSuCh78fGTTPao4FNIPJgD18R0R
	9ICxsp+oyviXuT17uvTQJl7uktjWTC5gHBVohPPnzt5G93gOXiFzSOAoKFzoNxDcXGMudh8sve9
	JuK6n4L8QLXTjzb9fc8ZDNgi7E2zoIirFBRjyfsMzDlECFyN2psCIH4vpyNo++HI1dSe+DebDr5
	gzQDgCjtd60Ux4HU/f352nbR6TjlI4mW+wE9A=
X-Google-Smtp-Source: AGHT+IFu12NV5C3ZMb+GzTshy782WYZvWJoPnURdrRS7I9I9BogTqLlIkKyKPKA2EoshONrHEKmUHw==
X-Received: by 2002:a05:6a00:4b12:b0:7a4:f552:b522 with SMTP id d2e1a72fcca58-7ba3c669976mr2406190b3a.27.1763100167825;
        Thu, 13 Nov 2025 22:02:47 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:22d2:323c:497d:adbd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ba438bed8csm1236316b3a.53.2025.11.13.22.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 22:02:47 -0800 (PST)
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
Subject: [PATCH v5 6/6] ceph: replace local base64 helpers with lib/base64
Date: Fri, 14 Nov 2025 14:02:40 +0800
Message-Id: <20251114060240.89965-1-409411716@gms.tku.edu.tw>
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

Remove the ceph_base64_encode() and ceph_base64_decode() functions and
replace their usage with the generic base64_encode() and base64_decode()
helpers from lib/base64.

This eliminates the custom implementation in Ceph, reduces code
duplication, and relies on the shared Base64 code in lib.
The helpers preserve RFC 3501-compliant Base64 encoding without padding,
so there are no functional changes.

This change also improves performance: encoding is about 2.7x faster and
decoding achieves 43-52x speedups compared to the previous local
implementation.

Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 fs/ceph/crypto.c | 60 ++++--------------------------------------------
 fs/ceph/crypto.h |  6 +----
 fs/ceph/dir.c    |  5 ++--
 fs/ceph/inode.c  |  2 +-
 4 files changed, 9 insertions(+), 64 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 7026e794813c..b6016dcffbb6 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -15,59 +15,6 @@
 #include "mds_client.h"
 #include "crypto.h"
 
-/*
- * The base64url encoding used by fscrypt includes the '_' character, which may
- * cause problems in snapshot names (which can not start with '_').  Thus, we
- * used the base64 encoding defined for IMAP mailbox names (RFC 3501) instead,
- * which replaces '-' and '_' by '+' and ','.
- */
-static const char base64_table[65] =
-	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,";
-
-int ceph_base64_encode(const u8 *src, int srclen, char *dst)
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
-			*cp++ = base64_table[(ac >> bits) & 0x3f];
-		} while (bits >= 6);
-	}
-	if (bits)
-		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
-	return cp - dst;
-}
-
-int ceph_base64_decode(const char *src, int srclen, u8 *dst)
-{
-	u32 ac = 0;
-	int bits = 0;
-	int i;
-	u8 *bp = dst;
-
-	for (i = 0; i < srclen; i++) {
-		const char *p = strchr(base64_table, src[i]);
-
-		if (p == NULL || src[i] == 0)
-			return -1;
-		ac = (ac << 6) | (p - base64_table);
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
 static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -318,7 +265,7 @@ int ceph_encode_encrypted_dname(struct inode *parent, char *buf, int elen)
 	}
 
 	/* base64 encode the encrypted name */
-	elen = ceph_base64_encode(cryptbuf, len, p);
+	elen = base64_encode(cryptbuf, len, p, false, BASE64_IMAP);
 	doutc(cl, "base64-encoded ciphertext name = %.*s\n", elen, p);
 
 	/* To understand the 240 limit, see CEPH_NOHASH_NAME_MAX comments */
@@ -412,7 +359,8 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 			tname = &_tname;
 		}
 
-		declen = ceph_base64_decode(name, name_len, tname->name);
+		declen = base64_decode(name, name_len,
+				       tname->name, false, BASE64_IMAP);
 		if (declen <= 0) {
 			ret = -EIO;
 			goto out;
@@ -426,7 +374,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 
 	ret = fscrypt_fname_disk_to_usr(dir, 0, 0, &iname, oname);
 	if (!ret && (dir != fname->dir)) {
-		char tmp_buf[CEPH_BASE64_CHARS(NAME_MAX)];
+		char tmp_buf[BASE64_CHARS(NAME_MAX)];
 
 		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
 				    oname->len, oname->name, dir->i_ino);
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 23612b2e9837..b748e2060bc9 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -8,6 +8,7 @@
 
 #include <crypto/sha2.h>
 #include <linux/fscrypt.h>
+#include <linux/base64.h>
 
 #define CEPH_FSCRYPT_BLOCK_SHIFT   12
 #define CEPH_FSCRYPT_BLOCK_SIZE    (_AC(1, UL) << CEPH_FSCRYPT_BLOCK_SHIFT)
@@ -89,11 +90,6 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
  */
 #define CEPH_NOHASH_NAME_MAX (180 - SHA256_DIGEST_SIZE)
 
-#define CEPH_BASE64_CHARS(nbytes) DIV_ROUND_UP((nbytes) * 4, 3)
-
-int ceph_base64_encode(const u8 *src, int srclen, char *dst);
-int ceph_base64_decode(const char *src, int srclen, u8 *dst);
-
 void ceph_fscrypt_set_ops(struct super_block *sb);
 
 void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index d18c0eaef9b7..0fa7c7777242 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -998,13 +998,14 @@ static int prep_encrypted_symlink_target(struct ceph_mds_request *req,
 	if (err)
 		goto out;
 
-	req->r_path2 = kmalloc(CEPH_BASE64_CHARS(osd_link.len) + 1, GFP_KERNEL);
+	req->r_path2 = kmalloc(BASE64_CHARS(osd_link.len) + 1, GFP_KERNEL);
 	if (!req->r_path2) {
 		err = -ENOMEM;
 		goto out;
 	}
 
-	len = ceph_base64_encode(osd_link.name, osd_link.len, req->r_path2);
+	len = base64_encode(osd_link.name, osd_link.len,
+			    req->r_path2, false, BASE64_IMAP);
 	req->r_path2[len] = '\0';
 out:
 	fscrypt_fname_free_buffer(&osd_link);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index a6e260d9e420..b691343cb7f1 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -958,7 +958,7 @@ static int decode_encrypted_symlink(struct ceph_mds_client *mdsc,
 	if (!sym)
 		return -ENOMEM;
 
-	declen = ceph_base64_decode(encsym, enclen, sym);
+	declen = base64_decode(encsym, enclen, sym, false, BASE64_IMAP);
 	if (declen < 0) {
 		pr_err_client(cl,
 			"can't decode symlink (%d). Content: %.*s\n",
-- 
2.34.1


