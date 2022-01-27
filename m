Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858C449EA8B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jan 2022 19:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242668AbiA0Sqh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jan 2022 13:46:37 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4535 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237163AbiA0Sqd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jan 2022 13:46:33 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jl8bl3Zwxz685ZV;
        Fri, 28 Jan 2022 02:42:59 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 19:46:30 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <linux-integrity@vger.kernel.org>
CC:     <zohar@linux.ibm.com>, <ebiggers@kernel.org>,
        <stefanb@linux.ibm.com>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [RFC][PATCH v3a 09/11] ima: Add support for fsverity signatures
Date:   Thu, 27 Jan 2022 19:46:13 +0100
Message-ID: <20220127184614.2837938-5-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220127184614.2837938-1-roberto.sassu@huawei.com>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Since fsverity signatures are in PKCS#7 format, handle them as the same as
kernel modules, using the modsig code.

The main differences with modsig are: ima_read_fsverity_sig() gets the
fsverity signature with fsverity_get_signature() instead of getting it from
the file content; ima_collect_fsverity() gets the data to be hashed from
fsverity_get_formatted_digest(), instead of hashing the file content.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 Documentation/ABI/testing/ima_policy     | 10 ++++
 Documentation/security/IMA-templates.rst |  7 ++-
 include/linux/evm.h                      |  5 ++
 security/integrity/ima/ima.h             | 19 ++++++
 security/integrity/ima/ima_api.c         | 38 ++++--------
 security/integrity/ima/ima_appraise.c    | 67 ++++++++++++++++++---
 security/integrity/ima/ima_main.c        | 32 ++++++++++
 security/integrity/ima/ima_modsig.c      | 75 ++++++++++++++++++++++++
 8 files changed, 217 insertions(+), 36 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 444bb7ccbe03..8602f08d06bb 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -151,6 +151,16 @@ Description:
 
 			appraise func=SETXATTR_CHECK appraise_algos=sha256,sha384,sha512
 
+		Example of measure and appraise rules allowing fs-verity
+		signed digests on a particular filesystem identified by
+		it's fsuuid:
+
+			measure func=BPRM_CHECK digest_type=hash|verity \
+				fsuuid=... template=ima-modsig
+			appraise func=BPRM_CHECK digest_type=hash|verity \
+				ima_appraise_type=imasig fsuuid=...
+
+
 		Example of measure rule allowing fs-verity's digests on a
 		particular filesystem with indication of type of digest.
 
diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
index 5e31513e8ec4..96654e72a36e 100644
--- a/Documentation/security/IMA-templates.rst
+++ b/Documentation/security/IMA-templates.rst
@@ -68,11 +68,12 @@ descriptors by adding their identifier to the format string
  - 'd-ng': the digest of the event, calculated with an arbitrary hash
    algorithm (field format: [<hash algo>:]digest, where the digest
    prefix is shown only if the hash algorithm is not SHA1 or MD5);
- - 'd-modsig': the digest of the event without the appended modsig;
+ - 'd-modsig': the digest of the event without the appended modsig, or the
+   digest of an fsverity formatted digest;
  - 'd-type': the type of file digest (e.g. hash, verity[1]);
  - 'n-ng': the name of the event, without size limitations;
- - 'sig': the file signature, or the EVM portable signature if the file
-   signature is not found;
+ - 'sig': the file signature, based on either the file's/fsverity's digest[1],
+   or the EVM portable signature if the file signature is not found;
  - 'modsig' the appended file signature;
  - 'buf': the buffer data that was used to generate the hash without size limitations;
  - 'evmsig': the EVM portable signature;
diff --git a/include/linux/evm.h b/include/linux/evm.h
index 4c374be70247..3da25393b011 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -14,6 +14,11 @@
 
 struct integrity_iint_cache;
 
+static inline bool evm_protects_fsverity(void)
+{
+	return false;
+}
+
 #ifdef CONFIG_EVM
 extern int evm_set_key(void *key, size_t keylen);
 extern enum integrity_status evm_verifyxattr(struct dentry *dentry,
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 78395bed7fad..4a45a7b5743b 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -380,26 +380,45 @@ static inline int ima_read_xattr(struct dentry *dentry,
 #endif /* CONFIG_IMA_APPRAISE */
 
 #ifdef CONFIG_IMA_APPRAISE_MODSIG
+bool ima_modsig_is_verity(const struct modsig *modsig);
 int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
 		    struct modsig **modsig);
+int ima_read_fsverity_sig(struct inode *inode, struct modsig **modsig);
 void ima_collect_modsig(struct modsig *modsig, const void *buf, loff_t size);
+void ima_collect_fsverity(struct modsig *modsig, const void *buf, loff_t size);
 int ima_get_modsig_digest(const struct modsig *modsig, enum hash_algo *algo,
 			  const u8 **digest, u32 *digest_size);
 int ima_get_raw_modsig(const struct modsig *modsig, const void **data,
 		       u32 *data_len);
 void ima_free_modsig(struct modsig *modsig);
 #else
+static inline bool ima_modsig_is_verity(const struct modsig *modsig)
+{
+	return false;
+}
+
 static inline int ima_read_modsig(enum ima_hooks func, const void *buf,
 				  loff_t buf_len, struct modsig **modsig)
 {
 	return -EOPNOTSUPP;
 }
 
+static inline int ima_read_fsverity_sig(struct inode *inode,
+					struct modsig **modsig)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void ima_collect_modsig(struct modsig *modsig, const void *buf,
 				      loff_t size)
 {
 }
 
+static inline void ima_collect_fsverity(struct modsig *modsig, const void *buf,
+					loff_t size)
+{
+}
+
 static inline int ima_get_modsig_digest(const struct modsig *modsig,
 					enum hash_algo *algo, const u8 **digest,
 					u32 *digest_size)
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 8760c4874f7d..369f2222dd55 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -201,23 +201,6 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
 				allowed_algos);
 }
 
-static int ima_get_verity_digest(struct integrity_iint_cache *iint,
-				 struct ima_digest_data *hash)
-{
-	u8 verity_digest[FS_VERITY_MAX_DIGEST_SIZE];
-	enum hash_algo verity_alg;
-	int rc;
-
-	rc = fsverity_get_digest(iint->inode, verity_digest, &verity_alg);
-	if (rc)
-		return -EINVAL;
-	if (hash->algo != verity_alg)
-		return -EINVAL;
-	hash->length = hash_digest_size[verity_alg];
-	memcpy(hash->digest, verity_digest, hash->length);
-	return 0;
-}
-
 /*
  * ima_collect_measurement - collect file measurement
  *
@@ -249,8 +232,12 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	 * the file digest without collecting the modsig in a previous
 	 * measurement rule.
 	 */
-	if (modsig)
-		ima_collect_modsig(modsig, buf, size);
+	if (modsig) {
+		if (!ima_modsig_is_verity(modsig))
+			ima_collect_modsig(modsig, buf, size);
+		else
+			ima_collect_fsverity(modsig, buf, size);
+	}
 
 	if (iint->flags & IMA_COLLECTED)
 		goto out;
@@ -266,14 +253,13 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	/* Initialize hash digest to 0's in case of failure */
 	memset(&hash.digest, 0, sizeof(hash.digest));
 
-	if (buf) {
+	if (buf && !(iint->flags & IMA_VERITY_DIGEST)) {
 		result = ima_calc_buffer_hash(buf, size, &hash.hdr);
-	} else if (iint->flags & IMA_VERITY_ALLOWED) {
-		result = ima_get_verity_digest(iint, &hash.hdr);
-		if (result < 0)
-			result = ima_calc_file_hash(file, &hash.hdr);
-		else
-			iint->flags |= IMA_VERITY_DIGEST;
+	} else if (buf && (iint->flags & IMA_VERITY_DIGEST)) {
+		hash.hdr.length = hash_digest_size[algo];
+		memcpy(hash.hdr.digest,
+		       ((struct fsverity_formatted_digest *)buf)->digest,
+		       hash_digest_size[algo]);
 	} else {
 		result = ima_calc_file_hash(file, &hash.hdr);
 	}
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 17232bbfb9f9..f8dde59e64f5 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -320,7 +320,7 @@ static int modsig_verify(enum ima_hooks func, const struct modsig *modsig,
 
 	rc = integrity_modsig_verify(INTEGRITY_KEYRING_IMA, modsig);
 	if (IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING) && rc &&
-	    func == KEXEC_KERNEL_CHECK)
+	    func == KEXEC_KERNEL_CHECK && !ima_modsig_is_verity(modsig))
 		rc = integrity_modsig_verify(INTEGRITY_KEYRING_PLATFORM,
 					     modsig);
 	if (rc) {
@@ -333,6 +333,50 @@ static int modsig_verify(enum ima_hooks func, const struct modsig *modsig,
 	return rc;
 }
 
+/*
+ * fsverity_verify - verify fsverity signature
+ *
+ * Verify whether the fsverity signature is valid.
+ *
+ * Return 0 on success, error code otherwise.
+ */
+static int fsverity_verify(struct integrity_iint_cache *iint,
+			   const struct modsig *modsig,
+			   enum integrity_status *status, const char **cause)
+{
+	int rc = -EINVAL;
+
+	if (!modsig || !ima_modsig_is_verity(modsig)) {
+		if (!evm_protects_fsverity()) {
+			*cause = "EVM-fsverity-not-protected";
+			*status = INTEGRITY_FAIL;
+			return rc;
+		}
+
+		if (*status != INTEGRITY_PASS_IMMUTABLE) {
+			if (iint->flags & IMA_DIGSIG_REQUIRED) {
+				*cause = "IMA-signature-required";
+				*status = INTEGRITY_FAIL;
+				return rc;
+			}
+			clear_bit(IMA_DIGSIG, &iint->atomic_flags);
+		} else {
+			set_bit(IMA_DIGSIG, &iint->atomic_flags);
+		}
+
+		/*
+		 * EVM already verified the actual fsverity digest, nothing else
+		 * is required.
+		 */
+		*status = INTEGRITY_PASS;
+		rc = 0;
+	} else {
+		rc = modsig_verify(NONE, modsig, status, cause);
+	}
+
+	return rc;
+}
+
 /*
  * ima_check_blacklist - determine if the binary is blacklisted.
  *
@@ -352,7 +396,8 @@ int ima_check_blacklist(struct integrity_iint_cache *iint,
 	if (!(iint->flags & IMA_CHECK_BLACKLIST))
 		return 0;
 
-	if (iint->flags & IMA_MODSIG_ALLOWED && modsig) {
+	if (iint->flags & IMA_MODSIG_ALLOWED && modsig &&
+	    !ima_modsig_is_verity(modsig)) {
 		ima_get_modsig_digest(modsig, &hash_algo, &digest, &digestsize);
 
 		rc = is_binary_blacklisted(digest, digestsize);
@@ -385,14 +430,16 @@ int ima_appraise_measurement(enum ima_hooks func,
 	struct inode *inode = d_backing_inode(dentry);
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	int rc = xattr_len;
-	bool try_modsig = iint->flags & IMA_MODSIG_ALLOWED && modsig;
+	bool try_modsig = iint->flags & IMA_MODSIG_ALLOWED && modsig &&
+			  !ima_modsig_is_verity(modsig);
+	bool try_fsverity = iint->flags & IMA_VERITY_DIGEST;
 
-	/* If not appraising a modsig, we need an xattr. */
-	if (!(inode->i_opflags & IOP_XATTR) && !try_modsig)
+	/* If not appraising a modsig or an fsverity file, we need an xattr. */
+	if (!(inode->i_opflags & IOP_XATTR) && !try_modsig && !try_fsverity)
 		return INTEGRITY_UNKNOWN;
 
 	/* If reading the xattr failed and there's no modsig, error out. */
-	if (rc <= 0 && !try_modsig) {
+	if (rc <= 0 && !try_modsig && !try_fsverity) {
 		if (rc && rc != -ENODATA)
 			goto out;
 
@@ -446,6 +493,12 @@ int ima_appraise_measurement(enum ima_hooks func,
 	     rc == -ENOKEY))
 		rc = modsig_verify(func, modsig, &status, &cause);
 
+	/*
+	 * If we have a fsverity sig, no modsig and no imasig, then try
+	 * verifying the fsverity sig.
+	 */
+	if (try_fsverity)
+		rc = fsverity_verify(iint, modsig, &status, &cause);
 out:
 	/*
 	 * File signatures on some filesystems can not be properly verified.
@@ -463,7 +516,7 @@ int ima_appraise_measurement(enum ima_hooks func,
 	} else if (status != INTEGRITY_PASS) {
 		/* Fix mode, but don't replace file signatures. */
 		if ((ima_appraise & IMA_APPRAISE_FIX) && !try_modsig &&
-		    (!xattr_value ||
+		    !try_fsverity && (!xattr_value ||
 		     xattr_value->type != EVM_IMA_XATTR_DIGSIG)) {
 			if (!ima_fix_xattr(dentry, iint))
 				status = INTEGRITY_PASS;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 774accb62275..1f78f31c3e89 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -25,6 +25,7 @@
 #include <linux/xattr.h>
 #include <linux/ima.h>
 #include <linux/iversion.h>
+#include <linux/fsverity.h>
 #include <linux/fs.h>
 
 #include "ima.h"
@@ -216,6 +217,8 @@ static int process_measurement(struct file *file, const struct cred *cred,
 	bool violation_check;
 	enum hash_algo hash_algo;
 	unsigned int allowed_algos = 0;
+	u8 fsverity_buf[FS_VERITY_MAX_FMT_DIGEST_SIZE];
+	ssize_t fsverity_buf_len;
 
 	if (!ima_policy_flag || !S_ISREG(inode->i_mode))
 		return 0;
@@ -330,9 +333,38 @@ static int process_measurement(struct file *file, const struct cred *cred,
 			    iint->flags & IMA_MEASURED)
 				action |= IMA_MEASURE;
 		}
+
+		/*
+		 * Read the fsverity sig if allowed by the policy, and allow
+		 * an additional measurement list entry, if needed, based on the
+		 * template format and whether the file was already measured.
+		 */
+		if (!modsig && IS_VERITY(inode) &&
+		    (iint->flags & IMA_VERITY_ALLOWED)) {
+			rc = ima_read_fsverity_sig(inode, &modsig);
+
+			if (!rc && ima_template_has_modsig(template_desc) &&
+			    iint->flags & IMA_MEASURED)
+				action |= IMA_MEASURE;
+		}
 	}
 
 	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
+	/*
+	 * Fsverity verification method is enabled only if all others are not
+	 * available.
+	 */
+	if (IS_VERITY(inode) && (iint->flags & IMA_VERITY_ALLOWED) &&
+	    !xattr_value && (!modsig || ima_modsig_is_verity(modsig))) {
+		fsverity_buf_len = fsverity_get_formatted_digest(inode,
+								 fsverity_buf,
+								 &hash_algo);
+		if (fsverity_buf_len > 0) {
+			buf = fsverity_buf;
+			size = fsverity_buf_len;
+			iint->flags |= IMA_VERITY_DIGEST;
+		}
+	}
 
 	rc = ima_collect_measurement(iint, file, buf, size, hash_algo, modsig);
 	if (rc != 0 && rc != -EBADF && rc != -EINVAL)
diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
index fb25723c65bc..66c19846477c 100644
--- a/security/integrity/ima/ima_modsig.c
+++ b/security/integrity/ima/ima_modsig.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/fsverity.h>
 #include <linux/module_signature.h>
 #include <keys/asymmetric-type.h>
 #include <crypto/pkcs7.h>
@@ -16,6 +17,8 @@
 #include "ima.h"
 
 struct modsig {
+	bool is_verity;
+
 	struct pkcs7_message *pkcs7_msg;
 
 	enum hash_algo hash_algo;
@@ -32,6 +35,11 @@ struct modsig {
 	u8 raw_pkcs7[];
 };
 
+bool ima_modsig_is_verity(const struct modsig *modsig)
+{
+	return modsig->is_verity;
+}
+
 /*
  * ima_read_modsig - Read modsig from buf.
  *
@@ -87,6 +95,51 @@ int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
 	return 0;
 }
 
+/*
+ * ima_read_fsverity_sig - Read fsverity sig from inode.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int ima_read_fsverity_sig(struct inode *inode, struct modsig **modsig)
+{
+	struct modsig *hdr;
+	u8 *signature;
+	ssize_t signature_size;
+	int rc;
+
+	signature_size = fsverity_get_signature(inode, &signature);
+	if (signature_size < 0)
+		return signature_size;
+
+	/*
+	 * Allocate signature_size additional bytes to hold the raw PKCS#7 data.
+	 */
+	hdr = kzalloc(sizeof(*hdr) + signature_size, GFP_KERNEL);
+	if (!hdr) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	hdr->pkcs7_msg = pkcs7_parse_message(signature, signature_size);
+	if (IS_ERR(hdr->pkcs7_msg)) {
+		rc = PTR_ERR(hdr->pkcs7_msg);
+		kfree(hdr);
+		goto out;
+	}
+
+	memcpy(hdr->raw_pkcs7, signature, signature_size);
+	hdr->raw_pkcs7_len = signature_size;
+
+	/* We don't know the hash algorithm yet. */
+	hdr->hash_algo = HASH_ALGO__LAST;
+	hdr->is_verity = true;
+
+	*modsig = hdr;
+out:
+	kfree(signature);
+	return rc;
+}
+
 /**
  * ima_collect_modsig - Calculate the file hash without the appended signature.
  *
@@ -113,6 +166,28 @@ void ima_collect_modsig(struct modsig *modsig, const void *buf, loff_t size)
 			      &modsig->digest_size, &modsig->hash_algo);
 }
 
+/**
+ * ima_collect_fsverity - Calculate the digest of the fsverity formatted digest.
+ *
+ * Pass the same data used to verify the fsverity signature in
+ * fs/verity/signature.c.
+ */
+void ima_collect_fsverity(struct modsig *modsig, const void *buf, loff_t size)
+{
+	int rc;
+
+	rc = pkcs7_supply_detached_data(modsig->pkcs7_msg, buf, size);
+	if (rc)
+		return;
+
+	/*
+	 * Ask the PKCS7 code to calculate the digest of the fsverity formatted
+	 * digest.
+	 */
+	rc = pkcs7_get_digest(modsig->pkcs7_msg, &modsig->digest,
+			      &modsig->digest_size, &modsig->hash_algo);
+}
+
 int ima_modsig_verify(struct key *keyring, const struct modsig *modsig)
 {
 	return verify_pkcs7_message_sig(NULL, 0, modsig->pkcs7_msg, keyring,
-- 
2.32.0

