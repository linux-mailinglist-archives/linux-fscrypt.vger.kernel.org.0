Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55268287A7B
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Oct 2020 19:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgJHRBq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Oct 2020 13:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbgJHRBq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Oct 2020 13:01:46 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8145D21D7D;
        Thu,  8 Oct 2020 17:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602176505;
        bh=IPIHUhKQTR3oZFKgHCq4nhhn7A6xUIlzms8OzsEuF28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PwrHuqX4aQSTqSAKewP9aeFPjJKYJek1v/w0zHl5hesP93nf3Qq/+9wpPpItYfTVT
         TywQzt6+BOMyVmqgM67Juk77N/liRX2fjSxNRftNvRQoOG94cVzvYcIo6pgq96Z/Ff
         zqzPxj3RQDPuMVNOFqyaD7D55D1P5KvjrNxM8oEs=
Date:   Thu, 8 Oct 2020 10:01:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/3] add support for metadata encryption to F2FS
Message-ID: <20201008170143.GA1869638@gmail.com>
References: <20201005073606.1949772-1-satyat@google.com>
 <20201007210040.GB1530638@gmail.com>
 <20201007220500.GA2544297@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007220500.GA2544297@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 07, 2020 at 10:05:00PM +0000, Satya Tangirala wrote:
> > I notice this is missing the step I suggested to include the metadata encryption
> > key in the HKDF application-specific info string when deriving subkeys from the
> > fscrypt master keys.
> > 
> > The same effect could also be achieved by adding an additional level to the key
> > hierarchy: each HKDF key would be derived from a fscrypt master key and the
> > metadata encryption key.
> > 
> > We need one of those, to guarantee that the file contents encryption is at least
> > as strong as the "metadata encryption".
> >
> Yes - I didn't get around to that in the first version, but I'll add
> that too in the next version. I was going to go with the first approach
> before I saw your comment - is there one method you'd recommend going
> with over the other?

I'm not entirely sure, but I'm now leaning towards the second approach because
it would avoid adding additional work (another SHA-512 block) to all later key
derivations.  Also it would avoid having to add a super_block argument to
fscrypt_hkdf_expand().  But please ask Paul Crowley for his suggestion too.

Here's a quick untested patch to consider:

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index dca254590a70..67f8ba3098d3 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -319,6 +319,7 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 #define HKDF_CONTEXT_DIRHASH_KEY	5 /* info=file_nonce		*/
 #define HKDF_CONTEXT_IV_INO_LBLK_32_KEY	6 /* info=mode_num||fs_uuid	*/
 #define HKDF_CONTEXT_INODE_HASH_KEY	7 /* info=<empty>		*/
+#define HKDF_CONTEXT_MIX_METADATA_KEY	8 /* info=metadata_key		*/
 
 int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 			const u8 *info, unsigned int infolen,
@@ -600,6 +601,20 @@ int fscrypt_setup_v1_file_key(struct fscrypt_info *ci,
 
 int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci);
 
+/* metadata_crypt.c */
+
+#ifdef CONFIG_FS_ENCRYPTION_METADATA
+int fscrypt_mix_in_metadata_key(struct super_block *sb,
+				struct fscrypt_master_key_secret *secret);
+#else
+static inline int
+fscrypt_mix_in_metadata_key(struct super_block *sb,
+			    struct fscrypt_master_key_secret *secret)
+{
+	return 0;
+}
+#endif
+
 /* policy.c */
 
 bool fscrypt_policies_equal(const union fscrypt_policy *policy1,
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index 0cba7928446d..61d1f0aa802e 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -174,4 +174,5 @@ int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf)
 {
 	crypto_free_shash(hkdf->hmac_tfm);
+	hkdf->hmac_tfm = NULL;
 }
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index e74f239c4428..43453a7f77b1 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -494,6 +494,10 @@ static int add_master_key(struct super_block *sb,
 		 */
 		memzero_explicit(secret->raw, secret->size);
 
+		err = fscrypt_mix_in_metadata_key(sb, secret);
+		if (err)
+			return err;
+
 		/* Calculate the key identifier */
 		err = fscrypt_hkdf_expand(&secret->hkdf,
 					  HKDF_CONTEXT_KEY_IDENTIFIER, NULL, 0,
diff --git a/fs/crypto/metadata_crypt.c b/fs/crypto/metadata_crypt.c
index 5e16df130509..233e68c35504 100644
--- a/fs/crypto/metadata_crypt.c
+++ b/fs/crypto/metadata_crypt.c
@@ -13,6 +13,32 @@
 
 #include "fscrypt_private.h"
 
+/* TODO: add comment */
+int fscrypt_mix_in_metadata_key(struct super_block *sb,
+				struct fscrypt_master_key_secret *secret)
+{
+	u8 real_key[FSCRYPT_MAX_KEY_SIZE];
+	int err;
+
+	if (WARN_ON(secret->size > sizeof(real_key)))
+		return -EINVAL;
+
+	if (!sb->s_metadata_key)
+		return 0;
+
+	err = fscrypt_hkdf_expand(&secret->hkdf, HKDF_CONTEXT_MIX_METADATA_KEY,
+				  sb->s_metadata_key->raw,
+				  sb->s_metadata_key->size,
+				  real_key, secret->size);
+	if (err)
+		return err;
+
+	fscrypt_destroy_hkdf(&secret->hkdf);
+	err = fscrypt_init_hkdf(&secret->hkdf, real_key, secret->size);
+	memzero_explicit(real_key, secret->size);
+	return err;
+}
+
 /* TODO: mostly copied from keysetup_v1.c - maybe refactor this function */
 static int fscrypt_metadata_get_key_from_id(const char *prefix,
 					    char *descriptor_hex,
