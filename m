Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951564DB71D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Mar 2022 18:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357566AbiCPR2S (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Mar 2022 13:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357554AbiCPR2Q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Mar 2022 13:28:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E124DF71;
        Wed, 16 Mar 2022 10:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B375F617D1;
        Wed, 16 Mar 2022 17:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3D1C340E9;
        Wed, 16 Mar 2022 17:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647451621;
        bh=gMbBz6NRybOeWT5Zv2GvjYSD5c+i/BJe3Gy1cMKjdYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=laBluiYTkga0Wd2e6I+uxbZkBqCSs21lXPLvUgLcfHAIIS0hCyB/iMPnA9aT6UMpH
         xvr3sBheJ8HfMMHu46a7f8jl1kWv+dp2bFXoI5MZyB3W3IUU3MgzxEl5d+xTZq7sdM
         J455hh+kX9QTZPRLW2XTUitte7CkyyNbK/BehvNSGDMP3N7A2ce5g9+oJjFV95k4jF
         v2nm3MpmpqsyJkMWM4nTuq3V21ns5xaEZSTtQgvABKCBBQC3tN43M4e2/sFVFAPytA
         vkOg+i7gHymOQcq2nSF4HA3DhzRt95ztAYrYPTAwpw6BjQamSf7BADpzge6uNAT1bQ
         hv6wKhmWchI+A==
Date:   Wed, 16 Mar 2022 17:26:59 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v7 2/5] btrfs: test btrfs specific fsverity corruption
Message-ID: <YjId47Ta24xoEbW/@gmail.com>
References: <cover.1647382272.git.boris@bur.io>
 <a860be32471a885292c2f6f3136cac40bebdbf05.1647382272.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a860be32471a885292c2f6f3136cac40bebdbf05.1647382272.git.boris@bur.io>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Mar 15, 2022 at 03:15:58PM -0700, Boris Burkov wrote:
> There are some btrfs specific fsverity scenarios that don't map
> neatly onto the tests in generic/574 like holes, inline extents,
> and preallocated extents. Cover those in a btrfs specific test.
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
>  common/btrfs        |   5 ++
>  common/config       |   1 +
>  common/verity       |  14 ++++
>  tests/btrfs/290     | 168 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/290.out |  25 +++++++
>  5 files changed, 213 insertions(+)
>  create mode 100755 tests/btrfs/290
>  create mode 100644 tests/btrfs/290.out
> 
> diff --git a/common/btrfs b/common/btrfs
> index 670d9d1f..c3a7dc6e 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -511,3 +511,8 @@ _btrfs_metadump()
>  	$BTRFS_IMAGE_PROG "$device" "$dumpfile"
>  	[ -n "$DUMP_COMPRESSOR" ] && $DUMP_COMPRESSOR -f "$dumpfile" &> /dev/null
>  }
> +
> +_require_btrfs_corrupt_block()
> +{
> +	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs-corrupt-block
> +}
> diff --git a/common/config b/common/config
> index 479e50d1..67bdf912 100644
> --- a/common/config
> +++ b/common/config
> @@ -296,6 +296,7 @@ export BTRFS_UTIL_PROG=$(type -P btrfs)
>  export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
>  export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
>  export BTRFS_TUNE_PROG=$(type -P btrfstune)
> +export BTRFS_CORRUPT_BLOCK_PROG=$(type -P btrfs-corrupt-block)
>  export XFS_FSR_PROG=$(type -P xfs_fsr)
>  export MKFS_NFS_PROG="false"
>  export MKFS_CIFS_PROG="false"
> diff --git a/common/verity b/common/verity
> index 1afe4a82..77766fca 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -3,6 +3,8 @@
>  #
>  # Functions for setting up and testing fs-verity
>  
> +. common/btrfs
> +
>  _require_scratch_verity()
>  {
>  	_require_scratch
> @@ -48,6 +50,15 @@ _require_scratch_verity()
>  	FSV_BLOCK_SIZE=$(get_page_size)
>  }
>  
> +# Check for userspace tools needed to corrupt verity data or metadata.
> +_require_fsverity_corruption()
> +{
> +	_require_xfs_io_command "fiemap"
> +	if [ $FSTYP == "btrfs" ]; then
> +		_require_btrfs_corrupt_block
> +	fi
> +}

This is adding a second definition of _require_fsverity_corruption().
Probably a rebase error.

Also, is this hunk in the right patch?  This patch is for adding btrfs/290;
however, btrfs/290 doesn't use _require_fsverity_corruption() anymore.

> +
>  # Check for CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y, as well as the userspace
>  # commands needed to generate certificates and add them to the kernel.
>  _require_fsverity_builtin_signatures()
> @@ -153,6 +164,9 @@ _scratch_mkfs_verity()
>  	ext4|f2fs)
>  		_scratch_mkfs -O verity
>  		;;
> +	btrfs)
> +		_scratch_mkfs
> +		;;

I think a good way to organize things would be to wire up the existing verity
tests for btrfs first, then to add the btrfs-specific tests at thet end of the
series.  That would mean the above hunk would go earlier in the series, not with
btrfs/290.  It's a little hard to review as-is, as the different hunks needed to
wire up the existing tests are mixed around in different patches.

- Eric
