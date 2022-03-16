Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF7E4DB726
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Mar 2022 18:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345228AbiCPRao (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Mar 2022 13:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiCPRan (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Mar 2022 13:30:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0EC5B3C1;
        Wed, 16 Mar 2022 10:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E6E5B81C83;
        Wed, 16 Mar 2022 17:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8961C340E9;
        Wed, 16 Mar 2022 17:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647451766;
        bh=UgsoL5QTqmbRmR2bhrA9mhXgM2xfYwDiqz8+ReVP16g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oDW8PkcYhSo/MJcrlaGlMd4bMbat59poTR8CS12uMl/WDbeWy4haKFliku+4V4/7G
         QBd1GMSPbA2rLZ908Z36JzK/r3kQp1xFrFC772k/nu4WCr8XBRlhlRxEmdnzKIsU6b
         Q8h0fWPJVZ91mMuqsDunMuiSGzu8XApFooJIxvgxDNnRZoPv/W1dtoc/7zRML4ajEG
         MZ/QKImQ/d2rh0vTm7VjT12AbhopNrDTDG/Z7PeQVrpCNYsfekkKZhG4EGZeFFxPKM
         zr4HC1eDUx3ZpYMAEt6u2Cm86jEv28IvCqpyGu17u3WzIZ7dzu4ryWOCky+Qmm4fLO
         8D8jKg2WAVJxQ==
Date:   Wed, 16 Mar 2022 17:29:22 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v7 3/5] generic/574: corrupt btrfs merkle tree data
Message-ID: <YjIecjyuXQNedRF7@gmail.com>
References: <cover.1647382272.git.boris@bur.io>
 <6d08195d452509ebf0f8724fd3c25a7cd2079232.1647382272.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d08195d452509ebf0f8724fd3c25a7cd2079232.1647382272.git.boris@bur.io>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Mar 15, 2022 at 03:15:59PM -0700, Boris Burkov wrote:
> generic/574 has tests for corrupting the merkle tree data stored by the
> filesystem. Since btrfs uses a different scheme for storing this data,
> the existing logic for corrupting it doesn't work out of the box. Adapt
> it to properly corrupt btrfs merkle items.
> 
> This test relies on the btrfs implementation of fsverity in the patch:
> btrfs: initial fsverity support
> 
> and on btrfs-corrupt-block for corruption in the patches titled:
> btrfs-progs: corrupt generic item data with btrfs-corrupt-block
> btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  common/verity     | 15 +++++++++++++++
>  tests/generic/574 |  1 +
>  2 files changed, 16 insertions(+)
> 
> diff --git a/common/verity b/common/verity
> index 77766fca..db03510e 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -328,6 +328,21 @@ _fsv_scratch_corrupt_merkle_tree()
>  		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
>  		_fsv_scratch_corrupt_bytes $file $offset
>  		;;
> +	btrfs)
> +		local ino=$(stat -c '%i' $file)
> +		_scratch_unmount
> +		local byte=""
> +		while read -n 1 byte; do
> +			local ascii=$(printf "%d" "'$byte'")
> +			# This command will find a Merkle tree item for the inode (-I $ino,37,0)
> +			# in the default filesystem tree (-r 5) and corrupt one byte (-b 1) at
> +			# $offset (-o $offset) with the ascii representation of the byte we read
> +			# (-v $ascii)
> +			$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v $ascii -o $offset -b 1 $SCRATCH_DEV
> +			(( offset += 1 ))
> +		done
> +		_scratch_mount
> +		;;
>  	*)
>  		_fail "_fsv_scratch_corrupt_merkle_tree() unimplemented on $FSTYP"
>  		;;
> diff --git a/tests/generic/574 b/tests/generic/574
> index 17fdea52..18810ab2 100755
> --- a/tests/generic/574
> +++ b/tests/generic/574
> @@ -27,6 +27,7 @@ _cleanup()
>  # real QA test starts here
>  _supported_fs generic
>  _require_scratch_verity
> +_require_fsverity_corruption
>  _disable_fsverity_signatures
>  _require_fsverity_corruption
>  

_require_fsverity_corruption is already present above.

That would mean this patch should only change common/verity, and its subject
should have "common/verity", not "generic/574".

- Eric
