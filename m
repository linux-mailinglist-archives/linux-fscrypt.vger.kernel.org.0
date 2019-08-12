Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7D08A508
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 19:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfHLR5Q (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 13:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbfHLR5Q (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 13:57:16 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 180DD2075B;
        Mon, 12 Aug 2019 17:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565632634;
        bh=Q4ldZqJhDcqMdzBcCtfF3VNQ9TSIT/jJ5pshtq8rjFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnZi6tyZyNB0yt3vHwq0kYEN1kKhZxotmT3LgldlCz4w6XcmkevwtnzR9GqvhyJrZ
         Um30GyK67ERFfjzduIoW2bZvz0XP3lITdym9JeepUNv2ONLjvIFGu2PBjzAzsE/43a
         pQ/znkLU+ia5FiOAa2Z9Xoz5mvnA9WMHo5MiuV3Q=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 2/8] xfs_io/encrypt: update to UAPI definitions from Linux v5.4
Date:   Mon, 12 Aug 2019 10:56:28 -0700
Message-Id: <20190812175635.34186-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190812175635.34186-1-ebiggers@kernel.org>
References: <20190812175635.34186-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Update to the latest fscrypt UAPI definitions, including:

- New names for some existing definitions (FSCRYPT_ instead of FS_).
- New ioctls.
- New encryption mode numbers and flags.

This patch doesn't make any change to the program logic itself.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c | 160 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 122 insertions(+), 38 deletions(-)

diff --git a/io/encrypt.c b/io/encrypt.c
index e8766dc1..ac473ed7 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -15,42 +15,126 @@
 #endif
 
 /*
- * We may have to declare the fscrypt ioctls ourselves because someone may be
- * compiling xfsprogs with old kernel headers.  And since some old versions of
- * <linux/fs.h> declared the policy struct and ioctl numbers but not the flags
- * and modes, our declarations must be split into two conditional blocks.
+ * Declare the fscrypt ioctls if needed, since someone may be compiling xfsprogs
+ * with old kernel headers.  But <linux/fs.h> has already been included, so be
+ * careful not to declare things twice.
  */
 
-/* Policy struct and ioctl numbers */
+/* first batch of ioctls (Linux headers v4.6+) */
 #ifndef FS_IOC_SET_ENCRYPTION_POLICY
-#define FS_KEY_DESCRIPTOR_SIZE  8
+#define fscrypt_policy fscrypt_policy_v1
+#define FS_IOC_SET_ENCRYPTION_POLICY		_IOR('f', 19, struct fscrypt_policy)
+#define FS_IOC_GET_ENCRYPTION_PWSALT		_IOW('f', 20, __u8[16])
+#define FS_IOC_GET_ENCRYPTION_POLICY		_IOW('f', 21, struct fscrypt_policy)
+#endif
+
+/*
+ * Second batch of ioctls (Linux headers v5.4+), plus some renamings from FS_ to
+ * FSCRYPT_.  We don't bother defining the old names here.
+ */
+#ifndef FS_IOC_GET_ENCRYPTION_POLICY_EX
+
+#define FSCRYPT_POLICY_FLAGS_PAD_4		0x00
+#define FSCRYPT_POLICY_FLAGS_PAD_8		0x01
+#define FSCRYPT_POLICY_FLAGS_PAD_16		0x02
+#define FSCRYPT_POLICY_FLAGS_PAD_32		0x03
+#define FSCRYPT_POLICY_FLAGS_PAD_MASK		0x03
+#define FSCRYPT_POLICY_FLAG_DIRECT_KEY		0x04
+
+#define FSCRYPT_MODE_AES_256_XTS		1
+#define FSCRYPT_MODE_AES_256_CTS		4
+#define FSCRYPT_MODE_AES_128_CBC		5
+#define FSCRYPT_MODE_AES_128_CTS		6
+#define FSCRYPT_MODE_ADIANTUM			9
+
+/*
+ * In the headers for Linux v4.6 through v5.3, 'struct fscrypt_policy_v1' is
+ * already defined under its old name, 'struct fscrypt_policy'.  But it's fine
+ * to define it under its new name too.
+ *
+ * Note: "v1" policies really are version "0" in the API.
+ */
+#define FSCRYPT_POLICY_V1		0
+#define FSCRYPT_KEY_DESCRIPTOR_SIZE	8
+struct fscrypt_policy_v1 {
+	__u8 version;
+	__u8 contents_encryption_mode;
+	__u8 filenames_encryption_mode;
+	__u8 flags;
+	__u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
+};
 
-struct fscrypt_policy {
+#define FSCRYPT_POLICY_V2		2
+#define FSCRYPT_KEY_IDENTIFIER_SIZE	16
+struct fscrypt_policy_v2 {
 	__u8 version;
 	__u8 contents_encryption_mode;
 	__u8 filenames_encryption_mode;
 	__u8 flags;
-	__u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
-} __attribute__((packed));
-
-#define FS_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct fscrypt_policy)
-#define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
-#define FS_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct fscrypt_policy)
-#endif /* FS_IOC_SET_ENCRYPTION_POLICY */
-
-/* Policy flags and encryption modes */
-#ifndef FS_ENCRYPTION_MODE_AES_256_XTS
-#define FS_POLICY_FLAGS_PAD_4		0x00
-#define FS_POLICY_FLAGS_PAD_8		0x01
-#define FS_POLICY_FLAGS_PAD_16		0x02
-#define FS_POLICY_FLAGS_PAD_32		0x03
-#define FS_POLICY_FLAGS_PAD_MASK	0x03
-#define FS_POLICY_FLAGS_VALID		0x03
-
-#define FS_ENCRYPTION_MODE_INVALID	0
-#define FS_ENCRYPTION_MODE_AES_256_XTS	1
-#define FS_ENCRYPTION_MODE_AES_256_CTS	4
-#endif /* FS_ENCRYPTION_MODE_AES_256_XTS */
+	__u8 __reserved[4];
+	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+};
+
+#define FSCRYPT_MAX_KEY_SIZE		64
+
+#define FS_IOC_GET_ENCRYPTION_POLICY_EX		_IOWR('f', 22, __u8[9]) /* size + version */
+struct fscrypt_get_policy_ex_arg {
+	__u64 policy_size; /* input/output */
+	union {
+		__u8 version;
+		struct fscrypt_policy_v1 v1;
+		struct fscrypt_policy_v2 v2;
+	} policy; /* output */
+};
+
+#define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR	1
+#define FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER	2
+struct fscrypt_key_specifier {
+	__u32 type;	/* one of FSCRYPT_KEY_SPEC_TYPE_* */
+	__u32 __reserved;
+	union {
+		__u8 __reserved[32]; /* reserve some extra space */
+		__u8 descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
+		__u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+	} u;
+};
+
+#define FS_IOC_ADD_ENCRYPTION_KEY		_IOWR('f', 23, struct fscrypt_add_key_arg)
+struct fscrypt_add_key_arg {
+	struct fscrypt_key_specifier key_spec;
+	__u32 raw_size;
+	__u32 __reserved[9];
+	__u8 raw[];
+};
+
+#define FS_IOC_REMOVE_ENCRYPTION_KEY		_IOWR('f', 24, struct fscrypt_remove_key_arg)
+#define FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS	_IOWR('f', 25, struct fscrypt_remove_key_arg)
+struct fscrypt_remove_key_arg {
+	struct fscrypt_key_specifier key_spec;
+#define FSCRYPT_KEY_REMOVAL_STATUS_FLAG_FILES_BUSY	0x00000001
+#define FSCRYPT_KEY_REMOVAL_STATUS_FLAG_OTHER_USERS	0x00000002
+	__u32 removal_status_flags;	/* output */
+	__u32 __reserved[5];
+};
+
+#define FS_IOC_GET_ENCRYPTION_KEY_STATUS	_IOWR('f', 26, struct fscrypt_get_key_status_arg)
+struct fscrypt_get_key_status_arg {
+	/* input */
+	struct fscrypt_key_specifier key_spec;
+	__u32 __reserved[6];
+
+	/* output */
+#define FSCRYPT_KEY_STATUS_ABSENT		1
+#define FSCRYPT_KEY_STATUS_PRESENT		2
+#define FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED	3
+	__u32 status;
+#define FSCRYPT_KEY_STATUS_FLAG_ADDED_BY_SELF   0x00000001
+	__u32 status_flags;
+	__u32 user_count;
+	__u32 __out_reserved[13];
+};
+
+#endif /* !FS_IOC_GET_ENCRYPTION_POLICY_EX */
 
 static cmdinfo_t get_encpolicy_cmd;
 static cmdinfo_t set_encpolicy_cmd;
@@ -84,8 +168,8 @@ static const struct {
 	__u8 mode;
 	const char *name;
 } available_modes[] = {
-	{FS_ENCRYPTION_MODE_AES_256_XTS, "AES-256-XTS"},
-	{FS_ENCRYPTION_MODE_AES_256_CTS, "AES-256-CTS"},
+	{FSCRYPT_MODE_AES_256_XTS, "AES-256-XTS"},
+	{FSCRYPT_MODE_AES_256_CTS, "AES-256-CTS"},
 };
 
 static bool
@@ -131,12 +215,12 @@ mode2str(__u8 mode)
 }
 
 static const char *
-keydesc2str(__u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE])
+keydesc2str(__u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE])
 {
-	static char buf[2 * FS_KEY_DESCRIPTOR_SIZE + 1];
+	static char buf[2 * FSCRYPT_KEY_DESCRIPTOR_SIZE + 1];
 	int i;
 
-	for (i = 0; i < FS_KEY_DESCRIPTOR_SIZE; i++)
+	for (i = 0; i < FSCRYPT_KEY_DESCRIPTOR_SIZE; i++)
 		sprintf(&buf[2 * i], "%02x", master_key_descriptor[i]);
 
 	return buf;
@@ -176,9 +260,9 @@ set_encpolicy_f(int argc, char **argv)
 
 	/* Initialize the policy structure with default values */
 	memset(&policy, 0, sizeof(policy));
-	policy.contents_encryption_mode = FS_ENCRYPTION_MODE_AES_256_XTS;
-	policy.filenames_encryption_mode = FS_ENCRYPTION_MODE_AES_256_CTS;
-	policy.flags = FS_POLICY_FLAGS_PAD_16;
+	policy.contents_encryption_mode = FSCRYPT_MODE_AES_256_XTS;
+	policy.filenames_encryption_mode = FSCRYPT_MODE_AES_256_CTS;
+	policy.flags = FSCRYPT_POLICY_FLAGS_PAD_16;
 
 	/* Parse options */
 	while ((c = getopt(argc, argv, "c:n:f:v:")) != EOF) {
@@ -229,7 +313,7 @@ set_encpolicy_f(int argc, char **argv)
 		unsigned long long x;
 		int i;
 
-		if (strlen(keydesc) != FS_KEY_DESCRIPTOR_SIZE * 2) {
+		if (strlen(keydesc) != FSCRYPT_KEY_DESCRIPTOR_SIZE * 2) {
 			fprintf(stderr, "invalid key descriptor: %s\n",
 				keydesc);
 			return 0;
@@ -242,7 +326,7 @@ set_encpolicy_f(int argc, char **argv)
 			return 0;
 		}
 
-		for (i = 0; i < FS_KEY_DESCRIPTOR_SIZE; i++) {
+		for (i = 0; i < FSCRYPT_KEY_DESCRIPTOR_SIZE; i++) {
 			policy.master_key_descriptor[i] = x >> 56;
 			x <<= 8;
 		}
-- 
2.23.0.rc1.153.gdeed80330f-goog

