Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789D88A50D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 19:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfHLR5R (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 13:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfHLR5Q (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 13:57:16 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7A0C208C2;
        Mon, 12 Aug 2019 17:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565632635;
        bh=oH9KlgKFDqc8kCsonilIgiq7lHkfAjMLijL+1MmNtWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oy6biDKs+QvnwqjpLZzta8SnfvTCIFtLYsF5IROjbaFltrGcOzxqXtqNHSRncnayw
         coKdGSMCTQMlyPKKzeMFOqy/wKytyO3zmt2aPg8+L414lPxAKUeuHVRPg4ZqCPqa1f
         iM8NWGvUMxX/l8rh0FpV2+oTYi3fiWErEH98Ppcg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 5/8] xfs_io/encrypt: extend 'set_encpolicy' to support v2 policies
Date:   Mon, 12 Aug 2019 10:56:31 -0700
Message-Id: <20190812175635.34186-6-ebiggers@kernel.org>
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

Extend the 'set_encpolicy' xfs_io command to support setting v2
encryption policies, in addition to v1 encryption policies which it
currently supports.  This uses the same ioctl, where the 'version' field
at the beginning of the struct is used to determine whether the struct
is fscrypt_policy_v1 or fscrypt_policy_v2.

The command sets a v2 policy when the user either gave the longer key
specification used in such policies (a 16-byte master_key_identifier
rather than an 8-byte master_key_descriptor), or passed '-v 2'.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c      | 228 ++++++++++++++++++++++++++++++++++++----------
 man/man8/xfs_io.8 |  19 +++-
 2 files changed, 194 insertions(+), 53 deletions(-)

diff --git a/io/encrypt.c b/io/encrypt.c
index 5b92cfae..f982cd17 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -161,13 +161,18 @@ set_encpolicy_help(void)
 " assign an encryption policy to the currently open file\n"
 "\n"
 " Examples:\n"
-" 'set_encpolicy' - assign policy with default key [0000000000000000]\n"
-" 'set_encpolicy 0000111122223333' - assign policy with specified key\n"
+" 'set_encpolicy' - assign v1 policy with default key descriptor\n"
+"                   (0000000000000000)\n"
+" 'set_encpolicy -v 2' - assign v2 policy with default key identifier\n"
+"                        (00000000000000000000000000000000)\n"
+" 'set_encpolicy 0000111122223333' - assign v1 policy with given key descriptor\n"
+" 'set_encpolicy 00001111222233334444555566667777' - assign v2 policy with given\n"
+"                                                    key identifier\n"
 "\n"
 " -c MODE -- contents encryption mode\n"
 " -n MODE -- filenames encryption mode\n"
 " -f FLAGS -- policy flags\n"
-" -v VERSION -- version of policy structure\n"
+" -v VERSION -- policy version\n"
 "\n"
 " MODE can be numeric or one of the following predefined values:\n"
 "    AES-256-XTS, AES-256-CTS, AES-128-CBC, AES-128-CTS, Adiantum\n"
@@ -231,6 +236,35 @@ mode2str(__u8 mode)
 	return buf;
 }
 
+static int
+hexchar2bin(char c)
+{
+	if (c >= '0' && c <= '9')
+		return c - '0';
+	if (c >= 'a' && c <= 'f')
+		return 10 + (c - 'a');
+	if (c >= 'A' && c <= 'F')
+		return 10 + (c - 'A');
+	return -1;
+}
+
+static bool
+hex2bin(const char *hex, __u8 *bin, size_t bin_len)
+{
+	if (strlen(hex) != 2 * bin_len)
+		return false;
+
+	while (bin_len--) {
+		int hi = hexchar2bin(*hex++);
+		int lo = hexchar2bin(*hex++);
+
+		if (hi < 0 || lo < 0)
+			return false;
+		*bin++ = (hi << 4) | lo;
+	}
+	return true;
+}
+
 static const char *
 keydesc2str(const __u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE])
 {
@@ -255,6 +289,92 @@ keyid2str(const __u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
 	return buf;
 }
 
+static const char *
+keyspectype(const struct fscrypt_key_specifier *key_spec)
+{
+	switch (key_spec->type) {
+	case FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR:
+		return "descriptor";
+	case FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER:
+		return "identifier";
+	}
+	return "[unknown]";
+}
+
+static const char *
+keyspec2str(const struct fscrypt_key_specifier *key_spec)
+{
+	switch (key_spec->type) {
+	case FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR:
+		return keydesc2str(key_spec->u.descriptor);
+	case FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER:
+		return keyid2str(key_spec->u.identifier);
+	}
+	return "[unknown]";
+}
+
+static bool
+str2keydesc(const char *str,
+	    __u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE])
+{
+	if (!hex2bin(str, master_key_descriptor, FSCRYPT_KEY_DESCRIPTOR_SIZE)) {
+		fprintf(stderr, "invalid key descriptor: %s\n", str);
+		return false;
+	}
+	return true;
+}
+
+static bool
+str2keyid(const char *str,
+	  __u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
+{
+	if (!hex2bin(str, master_key_identifier, FSCRYPT_KEY_IDENTIFIER_SIZE)) {
+		fprintf(stderr, "invalid key identifier: %s\n", str);
+		return false;
+	}
+	return true;
+}
+
+/*
+ * Parse a key specifier (descriptor or identifier) given as a hex string.
+ *
+ *  8 bytes (16 hex chars) == key descriptor == v1 encryption policy.
+ * 16 bytes (32 hex chars) == key identifier == v2 encryption policy.
+ *
+ * If a policy_version is given (>= 0), then the corresponding type of key
+ * specifier is required.  Otherwise the specifier type and policy_version are
+ * determined based on the length of the given hex string.
+ *
+ * Returns the policy version, or -1 on error.
+ */
+static int
+str2keyspec(const char *str, int policy_version,
+	    struct fscrypt_key_specifier *key_spec)
+{
+	if (policy_version < 0) { /* version unspecified? */
+		size_t len = strlen(str);
+
+		if (len == 2 * FSCRYPT_KEY_DESCRIPTOR_SIZE) {
+			policy_version = FSCRYPT_POLICY_V1;
+		} else if (len == 2 * FSCRYPT_KEY_IDENTIFIER_SIZE) {
+			policy_version = FSCRYPT_POLICY_V2;
+		} else {
+			fprintf(stderr, "invalid key specifier: %s\n", str);
+			return -1;
+		}
+	}
+	if (policy_version == FSCRYPT_POLICY_V2) {
+		if (!str2keyid(str, key_spec->u.identifier))
+			return -1;
+		key_spec->type = FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER;
+	} else {
+		if (!str2keydesc(str, key_spec->u.descriptor))
+			return -1;
+		key_spec->type = FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR;
+	}
+	return policy_version;
+}
+
 static void
 test_for_v2_policy_support(void)
 {
@@ -375,46 +495,54 @@ static int
 set_encpolicy_f(int argc, char **argv)
 {
 	int c;
-	struct fscrypt_policy policy;
-
-	/* Initialize the policy structure with default values */
-	memset(&policy, 0, sizeof(policy));
-	policy.contents_encryption_mode = FSCRYPT_MODE_AES_256_XTS;
-	policy.filenames_encryption_mode = FSCRYPT_MODE_AES_256_CTS;
-	policy.flags = FSCRYPT_POLICY_FLAGS_PAD_16;
+	__u8 contents_encryption_mode = FSCRYPT_MODE_AES_256_XTS;
+	__u8 filenames_encryption_mode = FSCRYPT_MODE_AES_256_CTS;
+	__u8 flags = FSCRYPT_POLICY_FLAGS_PAD_16;
+	int version = -1; /* unspecified */
+	struct fscrypt_key_specifier key_spec;
+	union {
+		__u8 version;
+		struct fscrypt_policy_v1 v1;
+		struct fscrypt_policy_v2 v2;
+	} policy;
 
-	/* Parse options */
 	while ((c = getopt(argc, argv, "c:n:f:v:")) != EOF) {
 		switch (c) {
 		case 'c':
-			if (!parse_mode(optarg,
-					&policy.contents_encryption_mode)) {
-				fprintf(stderr, "invalid contents encryption "
-					"mode: %s\n", optarg);
+			if (!parse_mode(optarg, &contents_encryption_mode)) {
+				fprintf(stderr,
+					"invalid contents encryption mode: %s\n",
+					optarg);
 				return 0;
 			}
 			break;
 		case 'n':
-			if (!parse_mode(optarg,
-					&policy.filenames_encryption_mode)) {
-				fprintf(stderr, "invalid filenames encryption "
-					"mode: %s\n", optarg);
+			if (!parse_mode(optarg, &filenames_encryption_mode)) {
+				fprintf(stderr,
+					"invalid filenames encryption mode: %s\n",
+					optarg);
 				return 0;
 			}
 			break;
 		case 'f':
-			if (!parse_byte_value(optarg, &policy.flags)) {
+			if (!parse_byte_value(optarg, &flags)) {
 				fprintf(stderr, "invalid flags: %s\n", optarg);
 				return 0;
 			}
 			break;
-		case 'v':
-			if (!parse_byte_value(optarg, &policy.version)) {
+		case 'v': {
+			__u8 val;
+
+			if (!parse_byte_value(optarg, &val)) {
 				fprintf(stderr, "invalid policy version: %s\n",
 					optarg);
 				return 0;
 			}
+			if (val == 1) /* Just to avoid annoying people... */
+				val = FSCRYPT_POLICY_V1;
+			version = val;
 			break;
+		}
 		default:
 			return command_usage(&set_encpolicy_cmd);
 		}
@@ -425,40 +553,44 @@ set_encpolicy_f(int argc, char **argv)
 	if (argc > 1)
 		return command_usage(&set_encpolicy_cmd);
 
-	/* Parse key descriptor if specified */
+	/*
+	 * If unspecified, the key descriptor or identifier defaults to all 0's.
+	 * If the policy version is additionally unspecified, it defaults to v1.
+	 */
+	memset(&key_spec, 0, sizeof(key_spec));
 	if (argc > 0) {
-		const char *keydesc = argv[0];
-		char *tmp;
-		unsigned long long x;
-		int i;
-
-		if (strlen(keydesc) != FSCRYPT_KEY_DESCRIPTOR_SIZE * 2) {
-			fprintf(stderr, "invalid key descriptor: %s\n",
-				keydesc);
+		version = str2keyspec(argv[0], version, &key_spec);
+		if (version < 0)
 			return 0;
-		}
-
-		x = strtoull(keydesc, &tmp, 16);
-		if (tmp == keydesc || *tmp != '\0') {
-			fprintf(stderr, "invalid key descriptor: %s\n",
-				keydesc);
-			return 0;
-		}
+	}
+	if (version < 0) /* version unspecified? */
+		version = FSCRYPT_POLICY_V1;
 
-		for (i = 0; i < FSCRYPT_KEY_DESCRIPTOR_SIZE; i++) {
-			policy.master_key_descriptor[i] = x >> 56;
-			x <<= 8;
-		}
+	memset(&policy, 0, sizeof(policy));
+	policy.version = version;
+	if (version == FSCRYPT_POLICY_V2) {
+		policy.v2.contents_encryption_mode = contents_encryption_mode;
+		policy.v2.filenames_encryption_mode = filenames_encryption_mode;
+		policy.v2.flags = flags;
+		memcpy(policy.v2.master_key_identifier, key_spec.u.identifier,
+		       FSCRYPT_KEY_IDENTIFIER_SIZE);
+	} else {
+		/*
+		 * xfstests passes .version = 255 for testing.  Just use
+		 * 'struct fscrypt_policy_v1' for both v1 and unknown versions.
+		 */
+		policy.v1.contents_encryption_mode = contents_encryption_mode;
+		policy.v1.filenames_encryption_mode = filenames_encryption_mode;
+		policy.v1.flags = flags;
+		memcpy(policy.v1.master_key_descriptor, key_spec.u.descriptor,
+		       FSCRYPT_KEY_DESCRIPTOR_SIZE);
 	}
 
-	/* Set the encryption policy */
-	if (ioctl(file->fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) < 0) {
+	if (ioctl(file->fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) != 0) {
 		fprintf(stderr, "%s: failed to set encryption policy: %s\n",
 			file->name, strerror(errno));
 		exitcode = 1;
-		return 0;
 	}
-
 	return 0;
 }
 
@@ -478,7 +610,7 @@ encrypt_init(void)
 	set_encpolicy_cmd.name = "set_encpolicy";
 	set_encpolicy_cmd.cfunc = set_encpolicy_f;
 	set_encpolicy_cmd.args =
-		_("[-c mode] [-n mode] [-f flags] [-v version] [keydesc]");
+		_("[-c mode] [-n mode] [-f flags] [-v version] [keyspec]");
 	set_encpolicy_cmd.argmin = 0;
 	set_encpolicy_cmd.argmax = -1;
 	set_encpolicy_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 3dd34a0c..18fcde0f 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -701,12 +701,17 @@ Swaps extent forks between files. The current open file is the target. The donor
 file is specified by path. Note that file data is not copied (file content moves
 with the fork(s)).
 .TP
-.BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keydesc " ]"
+.BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keyspec " ]"
 On filesystems that support encryption, assign an encryption policy to the
 current file.
-.I keydesc
-is a 16-byte hex string which identifies the encryption key to use.
-If not specified, a "default" key descriptor of all 0's will be used.
+.I keyspec
+is a hex string which specifies the encryption key to use.  For v1 encryption
+policies,
+.I keyspec
+must be a 16-character hex string (8 bytes).  For v2 policies,
+.I keyspec
+must be a 32-character hex string (16 bytes).  If unspecified, an all-zeroes
+value is used.
 .RS 1.0i
 .PD 0
 .TP 0.4i
@@ -720,7 +725,11 @@ filenames encryption mode (e.g. AES-256-CTS)
 policy flags (numeric)
 .TP
 .BI \-v " version"
-version of policy structure (numeric)
+policy version.  Defaults to 1 or 2 depending on the length of
+.IR keyspec ;
+or to 1 if
+.I keyspec
+is unspecified.
 .RE
 .PD
 .TP
-- 
2.23.0.rc1.153.gdeed80330f-goog

