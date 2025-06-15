Return-Path: <linux-fscrypt+bounces-672-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F3EAADA109
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 Jun 2025 06:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E0E17A433D
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 Jun 2025 04:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9151FCCF8;
	Sun, 15 Jun 2025 04:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ho4jYYIK"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270B41BC3F;
	Sun, 15 Jun 2025 04:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749963226; cv=none; b=P9fC6RKlZ6sgvT+5vmgc+pPweoe9ME9oIKjZXprGqKm/vlyF1j2AknBF7mEE/LO/nsnHG2lTVYm9MkUZS+4Bl24qDnd7PSyarEiCQGQ/bRXyeYvK42jUXkN/SkOKOQ39Hkgcg40l1c3sKNhObuXcx+jp0bXvldXDoXCZDTU04ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749963226; c=relaxed/simple;
	bh=jKskpqcoXOguF1H1TjZ0pWmBZVDnOT0/xNqcoD0cSAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cop3fA0Y+VmkDss/3wxik55bKeBb8btHH/9XKnr48c0Ck0d+935PoyeOiRkdJHqwqDHT1YTH2on5ZpOnpZzwPD7/sh/u7nEGrCk0RW/6xM6W7z5LuT6J2/c4UetT9i0PXF3QYTb2CBcfG6mgpGXwtgoxsw8ftpN9yzEMvtNftDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ho4jYYIK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560C4C4CEE3;
	Sun, 15 Jun 2025 04:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749963225;
	bh=jKskpqcoXOguF1H1TjZ0pWmBZVDnOT0/xNqcoD0cSAE=;
	h=From:To:Cc:Subject:Date:From;
	b=Ho4jYYIKxZ5jOqawvrhaEPBhEZPCrM8ChRozSncyaAqNV+riPwKkyanQnMEwAdbVm
	 /XRV6xyzV0raa/vd5Vhy6VpZ8GrTZtwKLpy7aNs7hKsQojtsMYvTe4DMgacX8pDInr
	 a0nfAZcxldXCif58iYfsInWiFqV6glddb5yOs9caUGyMCurbwn84kg4SOsvfVqmUGB
	 Wo3qxBpEPl9p0JEvf41ii0/lxxoogeSXHuFEhDZ2/SG3fUxUxujR9c7exo5bBPUZzE
	 GPlWpZSiPtJDcT+Br/m9zwgcOyyBKtPXd8G/lx6adWU0CoQnHdvVGNZu/NSTRtgW+q
	 /J7vgLI1jS06A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	ceph-devel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] fscrypt: don't use problematic non-inline crypto accelerators
Date: Sat, 14 Jun 2025 21:51:45 -0700
Message-ID: <20250615045145.224567-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Make fscrypt no longer use Crypto API drivers for non-inline crypto
accelerators, even when the Crypto API prioritizes them over CPU-based
code (which unfortunately it often does).  These drivers tend to be
really problematic, especially for fscrypt's synchronous workload.

Specifically, exclude drivers that have CRYPTO_ALG_KERN_DRIVER_ONLY or
CRYPTO_ALG_ALLOCATES_MEMORY set.  (Later, CRYPTO_ALG_ASYNC should be
excluded too.  That's omitted for now to keep this commit backportable,
since until recently some CPU-based code had CRYPTO_ALG_ASYNC set.)

There are two major issues with these drivers: bugs and performance.

First, these drivers tend to be buggy.  They're fundamentally much more
error-prone and harder to test than the CPU-based code, and they often
don't get tested before kernel releases.  Released drivers have
en/decrypted data incorrectly.  These bugs cause real issues for fscrypt
users who often didn't even want to use these drivers, for example:

- https://github.com/google/fscryptctl/issues/32
- https://github.com/google/fscryptctl/issues/9
- https://lore.kernel.org/r/PH0PR02MB731916ECDB6C613665863B6CFFAA2@PH0PR02MB7319.namprd02.prod.outlook.com

These drivers have also caused issues for dm-crypt users, including data
corruption and deadlocks.  Since Linux v5.10, dm-crypt has disabled most
of these drivers by excluding CRYPTO_ALG_ALLOCATES_MEMORY.

Second, the CPU-based crypto tends to be faster, often *much* faster.
This may seem counterintuitive, but benchmarks clearly show it.  There's
a *lot* of overhead associated with going to a hardware driver, off the
CPU, and back again.  Measuring synchronous AES-256-XTS encryption of
4096-byte messages (fscrypt's workload) on two platforms with non-inline
crypto accelerators that I have access to:

  Intel Emerald Rapids server:

     xts-aes-vaes-avx512:  16171 MB/s  [CPU-based, Vector AES]
     xts(ecb(aes-generic)):  305 MB/s  [CPU-based, generic C code]
     qat_aes_xts:            289 MB/s  [Offload, Intel QuickAssist]

  Qualcomm SM8650 HDK:

     xts-aes-ce:            4301 MB/s  [CPU-based, ARMv8 Crypto Extensions]
     xts(ecb(aes-generic)):  265 MB/s  [CPU-based, generic C code]
     xts-aes-qce:             73 MB/s  [Offload, Qualcomm Crypto Engine]

So, using the "accelerators" is over 50 times slower than just using the
CPU.  Not only that, it's even slower than the generic C code, which
suggests that even on platforms whose CPUs lack AES instructions the
performance benefit of any accelerator would be marginal at best.

The usefulness of the accelerators could be improved with a different
software architecture that allows blocks to be efficiently en/decrypted
in parallel.  But fscrypt does not do that today, and even the async
support in the Crypto API isn't really all that efficient.  And even if
the accelerator was used perfectly efficiently, it seems unlikely to
help on small I/O requests, for which latency is really important.

As of this writing, the Crypto API prioritizes qat_aes_xts over
xts-aes-vaes-avx512.  Therefore, this commit greatly improves fscrypt
performance on Intel servers that have QAT and the QAT driver enabled.
qat_aes_xts is going to be deprioritized in the Crypto API (like I did
for xts-aes-qce recently too).  But as this seems to be a common pattern
with all the "accelerators", fscrypt should just disable all of them.

An argument that has been given in favor of non-inline crypto
accelerators is that they can protect keys in hardware.  But fscrypt
does not take advantage of that, so it is irrelevant.  (Also, it would
be quite difficult for fscrypt to do that.)

Note that fscrypt does support inline encryption engines, using raw or
hardware-wrapped keys.  These actually do work well and are widely used.
These do not use the "Crypto API" and are unaffected by this commit.

Fixes: b30ab0e03407 ("ext4 crypto: add ext4 encryption facilities")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Changed in v2:
- Improved commit message and comment
- Dropped CRYPTO_ALG_ASYNC from the mask, to make this patch
  backport-friendly
- Added Fixes and Cc stable

 fs/crypto/fscrypt_private.h | 16 ++++++++++++++++
 fs/crypto/hkdf.c            |  2 +-
 fs/crypto/keysetup.c        |  3 ++-
 fs/crypto/keysetup_v1.c     |  3 ++-
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index c1d92074b65c5..0e95c7a095d49 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -43,10 +43,26 @@
  * hardware-wrapped keys has made it misleading as it's only for raw keys.
  * Don't use it in kernel code; use one of the above constants instead.
  */
 #undef FSCRYPT_MAX_KEY_SIZE
 
+/*
+ * This mask is passed as the third argument to the crypto_alloc_*() functions
+ * to prevent fscrypt from using the Crypto API drivers for non-inline crypto
+ * accelerators.  Those drivers have been problematic for fscrypt.  fscrypt
+ * users have reported hangs and even incorrect en/decryption with these
+ * drivers.  Since going to the driver, off CPU, and back again is really slow,
+ * such drivers can be over 50 times slower than the CPU-based code for
+ * fscrypt's synchronous workload.  Even on platforms that lack AES instructions
+ * on the CPU, any performance benefit is likely to be marginal at best.
+ *
+ * Note that fscrypt also supports inline encryption engines.  Those don't use
+ * the Crypto API and work much better than non-inline accelerators.
+ */
+#define FSCRYPT_CRYPTOAPI_MASK \
+	(CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_KERN_DRIVER_ONLY)
+
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
 #define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index 0f3028adc9c72..5b9c21cfe2b45 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -56,11 +56,11 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 	struct crypto_shash *hmac_tfm;
 	static const u8 default_salt[HKDF_HASHLEN];
 	u8 prk[HKDF_HASHLEN];
 	int err;
 
-	hmac_tfm = crypto_alloc_shash(HKDF_HMAC_ALG, 0, 0);
+	hmac_tfm = crypto_alloc_shash(HKDF_HMAC_ALG, 0, FSCRYPT_CRYPTOAPI_MASK);
 	if (IS_ERR(hmac_tfm)) {
 		fscrypt_err(NULL, "Error allocating " HKDF_HMAC_ALG ": %ld",
 			    PTR_ERR(hmac_tfm));
 		return PTR_ERR(hmac_tfm);
 	}
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 0d71843af9469..d8113a7196979 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -101,11 +101,12 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 			  const struct inode *inode)
 {
 	struct crypto_skcipher *tfm;
 	int err;
 
-	tfm = crypto_alloc_skcipher(mode->cipher_str, 0, 0);
+	tfm = crypto_alloc_skcipher(mode->cipher_str, 0,
+				    FSCRYPT_CRYPTOAPI_MASK);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT) {
 			fscrypt_warn(inode,
 				     "Missing crypto API support for %s (API name: \"%s\")",
 				     mode->friendly_name, mode->cipher_str);
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index b70521c55132b..158ceae8a5bce 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -50,11 +50,12 @@ static int derive_key_aes(const u8 *master_key,
 {
 	int res = 0;
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist src_sg, dst_sg;
-	struct crypto_skcipher *tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
+	struct crypto_skcipher *tfm =
+		crypto_alloc_skcipher("ecb(aes)", 0, FSCRYPT_CRYPTOAPI_MASK);
 
 	if (IS_ERR(tfm)) {
 		res = PTR_ERR(tfm);
 		tfm = NULL;
 		goto out;

base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.49.0


