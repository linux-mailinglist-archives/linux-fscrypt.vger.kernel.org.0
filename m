Return-Path: <linux-fscrypt+bounces-818-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76623B52A69
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 09:46:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B60801BC55DF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 07:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5775228DEE9;
	Thu, 11 Sep 2025 07:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="TDK4leq3"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661B4285C82
	for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 07:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757576790; cv=none; b=jxflpFeLSwPdVD9XP+luUE9O32hcfA85ymfjFnf+LbqPtLT0YGfqeV1lkYHa2/CrF7Qpf0uYybtXy053V8OBPdEY8w8oD7cf99IeOiTJmK+IMEbcoH79Jh90lQkIv/oEJMpo5NiBsRiXMM1Tb41XleuwfchqYBBKyUHIoK2MIRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757576790; c=relaxed/simple;
	bh=hyrovsqb25GvOk5ch0SE10QIDXuqIsRkz/P2XEfDCm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Oow/PojyGQrg6pIB+ZlEYssP+fHT6YEoS+Um9qHsLKzGDJ49D1riNX5NChKpQu51GVLUe/jjrXK1bKNMweeNc4UjMysfNbVKvm9bkyXqVlpgX7jA8lie70dvtpKD8L6/nfFaT1HVdVq9FOH+Jvua3F3sswgHKfe6Z5xp1GclA/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=TDK4leq3; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b5241e51764so361117a12.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 00:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757576788; x=1758181588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/o5UYWtgC17zidQRxgu3di44p2yuLDtqoBTP3KdD9qk=;
        b=TDK4leq3UlGV/qzuVwuOMXfh6wGfrcmPYnDlI+gt1yO9LJYLd5J86OM1yHMIosStXN
         QJVQRjBMCKcfr310lUmDDWlbCl0veaX7RPs1s630aPCwWRWnRebXEE5TLzCjnvWt9rto
         GnKHuEDVUJy8kOYs8oxSjJqS+WWkNBYALPglTcsryNg1jn/rFCi9Y4pV2WbeWX6dmey8
         Rlsfj3Ljc831tLj2taQWnrVtOQUtUQTo5YcwaeLFiPoNlrHvJw7ArM5y6PpWwCu7j/ZR
         ZrQH/V323u38WrV/1a2K6xwtN+TCuB2B0s9p+Jg26g3AMRwW4YHThbPPTfhTEvKMAl12
         rYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757576788; x=1758181588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/o5UYWtgC17zidQRxgu3di44p2yuLDtqoBTP3KdD9qk=;
        b=VXly1RW3CZrSo4aNB5hBhM7StwebiqgsbFWVf/BOaUfoIE1RjF7HG4HVAbh5G2LKwj
         Rc4LEuZwv9TwOpFqU9WnwIdBZRQcSNRr/skOX1L4G0un5vPCpsxLCrcQV86T0oUUFvJw
         4yE3vhKh5iffAhzSdFFycA7ldGMGNojaFcuinVO15NPR0dF0A/osp6i+uh9JOhKd1uP6
         3OJDu1+KVz/s0SyQ4wN8omwNBFfFgyA20GERyGeMLZiPebqn+islwEHOcRlvBgVKMYXP
         ChYHRIMBcy8uhJywfThjPqCimwUe5lJWmR6BdzYfDUCF4kzYaZqIs7NOinebJXtX0LnO
         LTFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUClfnDXEBx/bn5v67aMS/5nnt5Ao/B4AqjK5z0ovLqlMaHM3mRKra1F5trhqcdqCJxwvqM4Ba0GFAo1PsT@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbk+jyq9YBtYsjfp1rzkqI2DK7mzFCewxWh2tFk8jXR4q/U7iE
	3Pv61sEgjCnzwjfxyaY+JYkOH4XDt571R9CeYJpm5k+GlvHNhf9FrdNVXfkeA+mKgiM=
X-Gm-Gg: ASbGncvNgGrtV+uTMUBwQewjTmUwjINmQRSN6kmI4Zn8bAmd1X/I7JMTfA9u/AZm1rX
	uTX+JDCk5IhZqxwLruHAUN6x9p8VQCXyaFyntL7gRTbrYxj++naVV71h//zic8nuDOKcFRqAxg7
	bycT7MJ7h+oFUmqIvUce6HgAhsO5s/xyzk5LDq0AolqnzqIVKFDU5wSe2iDc2jdHwchJ4T+BB6Z
	hmQbFxNa23/SKODnC/ChiO/Ltqt4wiJJM0MKDXBkWh/8aJerxWz3ivRJM7k6JBEQHQu9yvTleo8
	hVU5UzYAwVP760VnmkeDjerySnDCxpMKjpH8aTq0jllGZ3LR2TgNMrmuy5DsjYctRwBXZGe/rOi
	Y9740/d4Ki3EO+xl1Sirm2q9y4lZpogQZFjYZHYpM3pVgxxC+E97lIeIZvdD+Njk/h3qL
X-Google-Smtp-Source: AGHT+IHUrbIDUjSvWXWDJnw2/rvjU/6tI+i+eOkABLbPn89zVIkTMb70/fAZWJUo/N9Zo8PVFcB0yA==
X-Received: by 2002:a05:6a20:939d:b0:24a:8315:7e2 with SMTP id adf61e73a8af0-2533fab6295mr27158794637.20.1757576787693;
        Thu, 11 Sep 2025 00:46:27 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:7811:c085:c184:85be])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607a47c47sm1152799b3a.35.2025.09.11.00.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 00:46:26 -0700 (PDT)
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
Subject: [PATCH v2 5/5] ceph: replace local base64 encode/decode with generic lib/base64 helpers
Date: Thu, 11 Sep 2025 15:46:17 +0800
Message-Id: <20250911074617.694704-1-409411716@gms.tku.edu.tw>
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

Remove the local ceph_base64_encode and ceph_base64_decode functions and
replace their usage with the generic base64_encode and base64_decode
helpers from the kernel's lib/base64 library.

This eliminates redundant implementations in Ceph, reduces code
duplication, and leverages the optimized and well-maintained
standard base64 code within the kernel.

The change keeps the existing encoding table and disables padding,
ensuring no functional or format changes. At the same time, Ceph also
benefits from the optimized encoder/decoder: encoding performance
improves by ~2.7x and decoding by ~12-15x compared to the previous
local implementation.

Overall, this improves maintainability, consistency with other kernel
components, and runtime performance.

Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 fs/ceph/crypto.c | 53 +++++-------------------------------------------
 fs/ceph/crypto.h |  6 ++----
 fs/ceph/dir.c    |  5 +++--
 fs/ceph/inode.c  |  2 +-
 4 files changed, 11 insertions(+), 55 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index cab722619..a3cb4ad99 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -21,53 +21,9 @@
  * used the base64 encoding defined for IMAP mailbox names (RFC 3501) instead,
  * which replaces '-' and '_' by '+' and ','.
  */
-static const char base64_table[65] =
+const char ceph_base64_table[65] =
 	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,";
 
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
@@ -316,7 +272,7 @@ int ceph_encode_encrypted_dname(struct inode *parent, char *buf, int elen)
 	}
 
 	/* base64 encode the encrypted name */
-	elen = ceph_base64_encode(cryptbuf, len, p);
+	elen = base64_encode(cryptbuf, len, p, false, ceph_base64_table);
 	doutc(cl, "base64-encoded ciphertext name = %.*s\n", elen, p);
 
 	/* To understand the 240 limit, see CEPH_NOHASH_NAME_MAX comments */
@@ -410,7 +366,8 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 			tname = &_tname;
 		}
 
-		declen = ceph_base64_decode(name, name_len, tname->name);
+		declen = base64_decode(name, name_len,
+				       tname->name, false, ceph_base64_table);
 		if (declen <= 0) {
 			ret = -EIO;
 			goto out;
@@ -424,7 +381,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 
 	ret = fscrypt_fname_disk_to_usr(dir, 0, 0, &iname, oname);
 	if (!ret && (dir != fname->dir)) {
-		char tmp_buf[CEPH_BASE64_CHARS(NAME_MAX)];
+		char tmp_buf[BASE64_CHARS(NAME_MAX)];
 
 		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
 				    oname->len, oname->name, dir->i_ino);
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 23612b2e9..c94da3818 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -8,6 +8,7 @@
 
 #include <crypto/sha2.h>
 #include <linux/fscrypt.h>
+#include <linux/base64.h>
 
 #define CEPH_FSCRYPT_BLOCK_SHIFT   12
 #define CEPH_FSCRYPT_BLOCK_SIZE    (_AC(1, UL) << CEPH_FSCRYPT_BLOCK_SHIFT)
@@ -89,10 +90,7 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
  */
 #define CEPH_NOHASH_NAME_MAX (180 - SHA256_DIGEST_SIZE)
 
-#define CEPH_BASE64_CHARS(nbytes) DIV_ROUND_UP((nbytes) * 4, 3)
-
-int ceph_base64_encode(const u8 *src, int srclen, char *dst);
-int ceph_base64_decode(const char *src, int srclen, u8 *dst);
+extern const char ceph_base64_table[65];
 
 void ceph_fscrypt_set_ops(struct super_block *sb);
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 8478e7e75..830715988 100644
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
+			    req->r_path2, false, ceph_base64_table);
 	req->r_path2[len] = '\0';
 out:
 	fscrypt_fname_free_buffer(&osd_link);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index fc543075b..94b729ccc 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -911,7 +911,7 @@ static int decode_encrypted_symlink(struct ceph_mds_client *mdsc,
 	if (!sym)
 		return -ENOMEM;
 
-	declen = ceph_base64_decode(encsym, enclen, sym);
+	declen = base64_decode(encsym, enclen, sym, false, ceph_base64_table);
 	if (declen < 0) {
 		pr_err_client(cl,
 			"can't decode symlink (%d). Content: %.*s\n",
-- 
2.34.1


