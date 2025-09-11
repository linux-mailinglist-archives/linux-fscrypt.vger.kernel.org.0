Return-Path: <linux-fscrypt+bounces-814-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BFCB52A14
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 09:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 579091C27387
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 07:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FE026CE39;
	Thu, 11 Sep 2025 07:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="JQzt7uBc"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4392741C9
	for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 07:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757575998; cv=none; b=Oqm46fhhcWOr9wSNiuntFJGbUKwIiVU0ARINxlDDAK1dS1g1aciWw3b6zYfxrO2sf/4piaMo6efirIPCpCOY+BjzGVvoOpnnDqQSsRtGWA1y3SjhCNbBUvWtXeCpun2SabFHfzCKSjUsA7z3WK/n3EJPXTMRAmyBDGAa/Wbcr4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757575998; c=relaxed/simple;
	bh=hyrovsqb25GvOk5ch0SE10QIDXuqIsRkz/P2XEfDCm4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I7n5571QSSxak2GF8BRtccsNVoRXP2B67tgrLfinspVdfS/skIl5FcpqXeLVHb4WFLcRvnTW1cY0I4SknaufdJ1QX4VNyCuFITMJxVsLDIc75/RmKwQl6ZVASZlUydCt9dHfHdmxjm8y9eaqL9QRAqI7u/aiOjDJj3SVZYaBpXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=JQzt7uBc; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4dc35711d9so347068a12.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 00:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757575996; x=1758180796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/o5UYWtgC17zidQRxgu3di44p2yuLDtqoBTP3KdD9qk=;
        b=JQzt7uBcEXxXdoS/XFxeIOEaG3PSpEuJjZeIDwzghW9z38aIErSUM/uLqBlDo9yEtU
         ldhFwwDJMZe638KHDDFRor/JtOGEAlEj6QGhoD/t/vg/h0nMbsXySU5lWSyFVUfPk8Sp
         igBFlM8PL/zIAaId3FyetrGfuVILNN8LrXj5WE/Auo4lAPTnqwBwSlk8eU8d+1WJrahA
         tiIVCufpGgl0+MZcSUK2G2KnHhuoRh7QoqUsYvxB8J0Cno9CkJce9TANu22B9lnp9ses
         1ecm5aPpRHyku09J88SUaBS9Li+KdEXgGenb8adGef0XkUO3+3CBeXCxHheY+E51E2d5
         qrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757575996; x=1758180796;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/o5UYWtgC17zidQRxgu3di44p2yuLDtqoBTP3KdD9qk=;
        b=KhXQLpf42K+iP9Zo1kWMPC1G2B6qgn41GI9O9DiRJzXgK4+eZNIhkyMdyyymSEkaCQ
         0PNPTKdFjK9snf9WS21uoUSQ3A1O0H7vLJyybR1KWY6Y6DHvCsYeWZd4jZ/EIhLbY2cH
         4VZFxLXRKGRC4kQJmls+RhQeUo8GkmpnGsOupfDYlhBdeI5Z/6I93CEc42IT5iqAADGs
         XQniL2aTZwpL8mzMjtZhbsAmnAxeRqNlbiW3z0OtAHQE6Ve8zu8X//3q6UQo0rC0pVCW
         Lr32Idweauk3lYYYOSdHgqy6ToZA5nWS6l05VV26jNGX0FMXjkIYZTyuekWzxz+p7+14
         XKJA==
X-Forwarded-Encrypted: i=1; AJvYcCWIU6TaCLNf9+6T9rUmRRehUptOQ5WPJsg0w89/Y3yKggc+8je3CfqVM6M8rxBnD0SEPNNI09maos8PmjRD@vger.kernel.org
X-Gm-Message-State: AOJu0Yx37FH5QyD5RbATh9eEVn5FdPJEcrqRPVG2MmaxUG2WkexY/rQ6
	0Fehs+QGJCX2fE+wjEbxllsP1EXQVjyEXJSdEIsNxX+BE5kgaSeRPHbwiVKlaFKvk+A=
X-Gm-Gg: ASbGncvTEzjYoa/tpN4/li2icyGa+9IWsyPsi+tzcofVFbqr0cFVUsiPZiINpkkODEV
	Fr41idRPWmB7llKJElG2p6M7SuI3XLnVV/pmZ0il3lszhY9gCLa5K+dbFfg9nAz5cBvLj61hZzc
	W0fcyLU1xCC3R+iNv5RGS4s2WNNiZwC7lBZbK5TlPGSSf5JfUtMa17AcFvTb/0CHght/wOnxwDi
	1j9Wvi1ekDIDW7PUUMvg7JCzmoPoQMSnJqrwrq592rMIqtiwRGR/KUw7kLOvQ95IYGN1hlPFgvS
	UJgcklvpLDSsXk73NYCp3UC70vGBWdllZ3A8KA+O2f1gWkIQJXt/DwBsycHXPdNoI+VSDtJ2LiI
	vldZ0um4+hvcaaZr7IfxDDVWuPCRV3NIz9D1OvEwPbFhrAXg=
X-Google-Smtp-Source: AGHT+IHkR02o3c7GJuOebqudxkkJpwwRFSiX+Y7xE72uJ4cvYA8ji6HSjHcG3eaIOtrt3exSDxeWQw==
X-Received: by 2002:a17:90a:ec85:b0:32b:4c71:f423 with SMTP id 98e67ed59e1d1-32d43f81c16mr21372566a91.32.1757575996006;
        Thu, 11 Sep 2025 00:33:16 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:7811:c085:c184:85be])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607b393f0sm1061340b3a.88.2025.09.11.00.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 00:33:15 -0700 (PDT)
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
Subject: [PATCH v2 5/5] ceph: replace local base64 encode/decode with generic lib/base64 helpers
Date: Thu, 11 Sep 2025 15:33:09 +0800
Message-Id: <20250911073309.584044-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
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


