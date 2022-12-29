Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3E4659333
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Dec 2022 00:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbiL2XfJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Dec 2022 18:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbiL2XfG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Dec 2022 18:35:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F98167CE;
        Thu, 29 Dec 2022 15:35:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4D7B61968;
        Thu, 29 Dec 2022 23:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDB0C43398;
        Thu, 29 Dec 2022 23:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672356904;
        bh=+7Jd5psu96Ge3avB3nbjvEb1i/yqFLwXtTavAaVo0jE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvSrOscolVUCWWuUSNRzErhdQDzKaixyoObU4WEhTj0jgNk/Fp4gDiPdoz0bxYtme
         au7XWs1H2k9ahnacigQgTLys4ed+cyTcROx6nLT6mCHit5k1skKLtarWVBL2nDtA3P
         Q3f51ppac26mEAe+WhfpVrv3xj3HmhTExp41i1eiqc/JJFY48c/D5aKIcmlVO4AymZ
         kx0xscZrEqR7WsP/60c90UUcpqhMxg7xvMiHyMrhBLkAWWNBt3Xxta134BbPfzE/TB
         2ZvKaA73zRk5EewSKRjbyw8mBmUZMm5gDMD85eWBoSOWXfrEshtjYdTx6ulT8CrC5e
         Ozl5dhBU+l5+w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 07/10] generic/577: support non-4K Merkle tree block size
Date:   Thu, 29 Dec 2022 15:32:19 -0800
Message-Id: <20221229233222.119630-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221229233222.119630-1-ebiggers@kernel.org>
References: <20221229233222.119630-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Update generic/577 to not implicitly assume that the Merkle tree block
size being used is 4096 bytes.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/577     | 22 ++++++++++++----------
 tests/generic/577.out | 10 +++++-----
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/tests/generic/577 b/tests/generic/577
index 85d680df..bbbfdb0a 100755
--- a/tests/generic/577
+++ b/tests/generic/577
@@ -38,6 +38,11 @@ sigfile=$tmp.sig
 otherfile=$SCRATCH_MNT/otherfile
 othersigfile=$tmp.othersig
 
+sign()
+{
+	_fsv_sign "$@" | _filter_scratch | _filter_fsverity_digest
+}
+
 # Setup
 
 echo -e "\n# Generating certificates and private keys"
@@ -57,14 +62,13 @@ _enable_fsverity_signatures
 echo -e "\n# Generating file and signing it for fs-verity"
 head -c 100000 /dev/zero > $fsv_orig_file
 for suffix in '' '.2'; do
-	_fsv_sign $fsv_orig_file $sigfile$suffix --key=$keyfile$suffix \
-		--cert=$certfile$suffix | _filter_scratch
+	sign $fsv_orig_file $sigfile$suffix --key=$keyfile$suffix \
+		--cert=$certfile$suffix
 done
 
 echo -e "\n# Signing a different file for fs-verity"
 head -c 100000 /dev/zero | tr '\0' 'X' > $otherfile
-_fsv_sign $otherfile $othersigfile --key=$keyfile --cert=$certfile \
-	| _filter_scratch
+sign $otherfile $othersigfile --key=$keyfile --cert=$certfile
 
 # Actual tests
 
@@ -106,16 +110,15 @@ _fsv_enable $fsv_file --signature=$tmp.malformed_sig |& _filter_scratch
 
 echo -e "\n# Testing salt"
 reset_fsv_file
-_fsv_sign $fsv_orig_file $sigfile.salted --key=$keyfile --cert=$certfile \
-	--salt=abcd | _filter_scratch
+sign $fsv_orig_file $sigfile.salted --key=$keyfile --cert=$certfile --salt=abcd
 _fsv_enable $fsv_file --signature=$sigfile.salted --salt=abcd
 cmp $fsv_file $fsv_orig_file
 
 echo -e "\n# Testing non-default hash algorithm"
 if _fsv_can_enable $fsv_file --hash-alg=sha512; then
 	reset_fsv_file
-	_fsv_sign $fsv_orig_file $sigfile.sha512 --key=$keyfile \
-		--cert=$certfile --hash-alg=sha512 > /dev/null
+	sign $fsv_orig_file $sigfile.sha512 --key=$keyfile --cert=$certfile \
+		--hash-alg=sha512 > /dev/null
 	_fsv_enable $fsv_file --signature=$sigfile.sha512 --hash-alg=sha512
 	cmp $fsv_file $fsv_orig_file
 fi
@@ -123,8 +126,7 @@ fi
 echo -e "\n# Testing empty file"
 rm -f $fsv_file
 echo -n > $fsv_file
-_fsv_sign $fsv_file $sigfile.emptyfile --key=$keyfile --cert=$certfile | \
-		_filter_scratch
+sign $fsv_file $sigfile.emptyfile --key=$keyfile --cert=$certfile
 _fsv_enable $fsv_file --signature=$sigfile.emptyfile
 
 # success, all done
diff --git a/tests/generic/577.out b/tests/generic/577.out
index 0ca417c4..4f360d57 100644
--- a/tests/generic/577.out
+++ b/tests/generic/577.out
@@ -9,11 +9,11 @@ QA output created by 577
 # Enabling fs.verity.require_signatures
 
 # Generating file and signing it for fs-verity
-Signed file 'SCRATCH_MNT/file' (sha256:ecabbfca4efd69a721be824965da10d27900b109549f96687b35a4d91d810dac)
-Signed file 'SCRATCH_MNT/file' (sha256:ecabbfca4efd69a721be824965da10d27900b109549f96687b35a4d91d810dac)
+Signed file 'SCRATCH_MNT/file' (sha256:<digest>)
+Signed file 'SCRATCH_MNT/file' (sha256:<digest>)
 
 # Signing a different file for fs-verity
-Signed file 'SCRATCH_MNT/otherfile' (sha256:b2a419c5a8c767a78c6275d6729794bf51e52ddf8713e31d12a93d61d961f49f)
+Signed file 'SCRATCH_MNT/otherfile' (sha256:<digest>)
 
 # Enabling verity with valid signature (should succeed)
 
@@ -33,9 +33,9 @@ ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': Key was rejected b
 ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': Bad message
 
 # Testing salt
-Signed file 'SCRATCH_MNT/file' (sha256:1cb173bcd199133eb80e9ea4f0f741001b9e73227aa8812685156f2bc8ff45f5)
+Signed file 'SCRATCH_MNT/file' (sha256:<digest>)
 
 # Testing non-default hash algorithm
 
 # Testing empty file
-Signed file 'SCRATCH_MNT/file.fsv' (sha256:3d248ca542a24fc62d1c43b916eae5016878e2533c88238480b26128a1f1af95)
+Signed file 'SCRATCH_MNT/file.fsv' (sha256:<digest>)
-- 
2.39.0

