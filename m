Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CBB486A9F
	for <lists+linux-fscrypt@lfdr.de>; Thu,  6 Jan 2022 20:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243426AbiAFTsC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 6 Jan 2022 14:48:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34368 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243403AbiAFTsB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 6 Jan 2022 14:48:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BCAEB82390;
        Thu,  6 Jan 2022 19:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D1BC36AE3;
        Thu,  6 Jan 2022 19:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641498478;
        bh=qG4P24v3rmLtQVZ3+9ve8/eqf1rVrXsPHnG9nhgApC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KrJ0kcx0NyoXAwr90aY0RBzRaQre/3bXHridHFAgDUq9ZXQt7ScnYGEouRVmTHaCS
         chWRZ2HIE+AOIQO7mR71i2psYYeUUVms2cUZs2oJ1auYHkguHNanzBbARYsTUyhfta
         qRRATijRtCLfxbK6gskf7D0HWlsfyYRc+5jcyFxX+DdRniNa/e8RhFroTngeOFt1yE
         nwD1YIbg3DWXjc2+9wKbSmwQS2Q+a3HUqUjGf7qdMunErvKGTG0GBN3Qye2/yY5IKF
         EPm4u7ZWGRbhuCEDngy3AOSrHenY7DbYOLUXOSjzSjBZJNSd+XQUNCEwmBTrfL7/46
         fQQbrcBPdiiIw==
Date:   Thu, 6 Jan 2022 11:47:57 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        quic_neersoni@quicinc.com, dineshg@quicinc.com
Subject: Re: [PATCH 00/10] Add wrapped key support for Qualcomm ICE
Message-ID: <YddHbRx2UGeAOhji@sol.localdomain>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Gaurav,

On Mon, Dec 06, 2021 at 02:57:15PM -0800, Gaurav Kashyap wrote:
> Testing:
> Test platform: SM8350 HDK/MTP
> Engineering trustzone image (based on sm8350) is required to test
> this feature. This is because of version changes of HWKM.
> HWKM version 2 and moving forward has a lot of restrictions on the
> key management due to which the launched SM8350 solution (based on v1)
> cannot be used and some modifications are required in trustzone.

I've been trying to test this patchset on a SM8350 HDK using the TrustZone image
you provided, but it's not completely working yet.

This is the kernel branch I'm using:
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git/log/?h=wip-wrapped-keys.
It has my v4 patchset with your patchset rebased on top of it, some qcom_scm.c
fixes I had to make (see below), and some extra logging messages.

This is how I'm building and booting a kernel on the board:
https://github.com/ebiggers/fscryptctl/blob/wip-wrapped-keys/scripts/sm8350-buildkernel.sh

And this is the test script I'm running:
https://github.com/ebiggers/fscryptctl/blob/wip-wrapped-keys/scripts/wrappedkey-test.sh.
It imports or generates a hardware-wrapped key, then tries to set up a directory
on an ext4 filesystem that is encrypted with that key.   This uses new
'fscryptctl' commands to access the new blk-crypto ioctls; the version of
'fscryptctl' on the branch the scripts are on has all the needed changes.

QCOM_SCM_ES_IMPORT_ICE_KEY, QCOM_SCM_ES_GENERATE_ICE_KEY,
QCOM_SCM_ES_PREPARE_ICE_KEY, all seem to work.  However,
QCOM_SCM_ES_DERIVE_SW_SECRET doesn't work; it always returns -EINVAL.

For example:

Importing hardware-wrapped key
[  187.606109] blk-crypto: entering BLKCRYPTOCREATEKEY
[  187.611648] calling QCOM_SCM_ES_IMPORT_ICE_KEY; raw_key=5858585858585858585858585858585858585858585858585858585858585858
[  187.628180] QCOM_SCM_ES_IMPORT_ICE_KEY succeeded; longterm_wrapped_key=fab51aa07fb6c2bf2fea60a8120e8d35a9e53865b594e0fb6279e7951a34864591f1c1c4e26f9421039377c1ac311ff9241a0152030000000000000000000000
[  187.646433] blk-crypto: exiting BLKCRYPTOCREATEKEY; ret=0
Preparing hardware-wrapped key
[  187.653129] blk-crypto: entering BLKCRYPTOPREPAREKEY
[  187.660356] calling QCOM_SCM_ES_PREPARE_ICE_KEY; longterm_wrapped_key=fab51aa07fb6c2bf2fea60a8120e8d35a9e53865b594e0fb6279e7951a34864591f1c1c4e26f9421039377c1ac311ff9241a0152030000000000000000000000
[  187.680420] QCOM_SCM_ES_PREPARE_ICE_KEY succeeded; ephemeral_wrapped_key=1fbf5d501854858d6faaf52c9d22bebc576012e40485ba75e7d19e88f74b3400eb1a8836e28232939e990df6007659b1241a0152030000000000000000000000
[  187.698791] blk-crypto: exiting BLKCRYPTOPREPAREKEY; ret=0
Adding hardware-wrapped key
[  187.705515] calling blk_crypto_derive_sw_secret(); wrapped_key_size=68
[  187.714075] in qti_ice_derive_sw_secret()
[  187.718212] calling qti_ice_hwkm_init()
[  187.722157] calling qti_ice_hwkm_init_sequence(version=1)
[  187.727715] setting standard mode
[  187.731134] checking BIST status
[  187.734464] configuring ICE registers
[  187.738230] disabling CRC check
[  187.741479] setting RSP_FIFO_FULL bit
[  187.745247] calling qcom_scm_derive_sw_secret()
[  187.749920] calling QCOM_SCM_ES_DERIVE_SW_SECRET; wrapped_key=1fbf5d501854858d6faaf52c9d22bebc576012e40485ba75e7d19e88f74b3400eb1a8836e28232939e990df6007659b1241a0152030000000000000000000000, secret_size=32
[  187.768834] QCOM_SCM_ES_DERIVE_SW_SECRET failed with error -22
[  187.774838] blk_crypto_derive_sw_secret() returned -22
error: adding key to /mnt: Invalid argument


You can see that the wrapped_key being passed to QCOM_SCM_ES_DERIVE_SW_SECRET
matches the ephemeral_wrapped_key that was returned earlier by
QCOM_SCM_ES_PREPARE_ICE_KEY, and that secret_size is 32.  So the arguments are
as expected.  However, QCOM_SCM_ES_DERIVE_SW_SECRET still fails.

This still occurs if QCOM_SCM_ES_GENERATE_ICE_KEY is used instead of
QCOM_SCM_ES_IMPORT_ICE_KEY.

Have you tested that QCOM_SCM_ES_DERIVE_SW_SECRET is working properly?

For reference, these are the fixes I had to apply to qcom_scm.c to get things
working until that point.  This included fixing the direction of the first
arguments to the SCM calls, and fixing the return values.  Note, I also tested
leaving QCOM_SCM_ES_DERIVE_SW_SECRET using QCOM_SCM_RO instead of QCOM_SCM_RW,
but the result was still the same --- it still returned -EINVAL.

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index d57f52015640..002b57a1473d 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -1087,7 +1087,7 @@ int qcom_scm_derive_sw_secret(const u8 *wrapped_key, u32 wrapped_key_size,
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd =  QCOM_SCM_ES_DERIVE_SW_SECRET,
-		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO,
+		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RW,
 					 QCOM_SCM_VAL, QCOM_SCM_RW,
 					 QCOM_SCM_VAL),
 		.args[1] = wrapped_key_size,
@@ -1148,7 +1148,7 @@ EXPORT_SYMBOL(qcom_scm_derive_sw_secret);
  * This SCM calls adds support for the generate key IOCTL to interface
  * with the secure environment to generate and return a wrapped key..
  *
- * Return: 0 on success; -errno on failure.
+ * Return: size of the resulting key on success; -errno on failure.
  */
 int qcom_scm_generate_ice_key(u8 *longterm_wrapped_key,
 			    u32 longterm_wrapped_key_size)
@@ -1188,7 +1188,7 @@ int qcom_scm_generate_ice_key(u8 *longterm_wrapped_key,
 	dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
 			  longterm_wrapped_keybuf, longterm_wrapped_key_phys);
 
-	return ret;
+	return ret ?: longterm_wrapped_key_size;
 }
 EXPORT_SYMBOL(qcom_scm_generate_ice_key);
 
@@ -1209,7 +1209,7 @@ EXPORT_SYMBOL(qcom_scm_generate_ice_key);
  * with the secure environment to rewrap the wrapped key with an
  * ephemeral wrapping key.
  *
- * Return: 0 on success; -errno on failure.
+ * Return: size of the resulting key on success; -errno on failure.
  */
 int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
 			     u32 longterm_wrapped_key_size,
@@ -1219,7 +1219,7 @@ int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd =  QCOM_SCM_ES_PREPARE_ICE_KEY,
-		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO,
+		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RW,
 					 QCOM_SCM_VAL, QCOM_SCM_RW,
 					 QCOM_SCM_VAL),
 		.args[1] = longterm_wrapped_key_size,
@@ -1270,7 +1270,7 @@ int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
 	dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
 			  longterm_wrapped_keybuf, longterm_wrapped_key_phys);
 
-	return ret;
+	return ret ?: ephemeral_wrapped_key_size;
 }
 EXPORT_SYMBOL(qcom_scm_prepare_ice_key);
 
@@ -1289,7 +1289,7 @@ EXPORT_SYMBOL(qcom_scm_prepare_ice_key);
  * the secure environment to import a raw key and generate a longterm
  * wrapped key.
  *
- * Return: 0 on success; -errno on failure.
+ * Return: size of the resulting key on success; -errno on failure.
  */
 int qcom_scm_import_ice_key(const u8 *imported_key, u32 imported_key_size,
 			    u8 *longterm_wrapped_key,
@@ -1298,7 +1298,7 @@ int qcom_scm_import_ice_key(const u8 *imported_key, u32 imported_key_size,
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd =  QCOM_SCM_ES_IMPORT_ICE_KEY,
-		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO,
+		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RW,
 					 QCOM_SCM_VAL, QCOM_SCM_RW,
 					 QCOM_SCM_VAL),
 		.args[1] = imported_key_size,
@@ -1344,7 +1344,7 @@ int qcom_scm_import_ice_key(const u8 *imported_key, u32 imported_key_size,
 	dma_free_coherent(__scm->dev, imported_key_size, imported_keybuf,
 			  imported_key_phys);
 
-	return ret;
+	return ret ?: longterm_wrapped_key_size;
 }
 EXPORT_SYMBOL(qcom_scm_import_ice_key);
