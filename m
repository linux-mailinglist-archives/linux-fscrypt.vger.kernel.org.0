Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBE2382004
	for <lists+linux-fscrypt@lfdr.de>; Sun, 16 May 2021 18:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhEPQjV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 May 2021 12:39:21 -0400
Received: from out20-85.mail.aliyun.com ([115.124.20.85]:33797 "EHLO
        out20-85.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhEPQjV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 May 2021 12:39:21 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1931724|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0924127-0.00107401-0.906513;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047205;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.KEFhWfr_1621183083;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KEFhWfr_1621183083)
          by smtp.aliyun-inc.com(10.147.43.95);
          Mon, 17 May 2021 00:38:03 +0800
Date:   Mon, 17 May 2021 00:38:03 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 2/4] generic/574: corrupt btrfs merkle tree data
Message-ID: <YKFKa9n4Porh3/gp@desktop>
References: <cover.1620248200.git.boris@bur.io>
 <1fce7bfd74d15ddc4492a642d275eec284910950.1620248200.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fce7bfd74d15ddc4492a642d275eec284910950.1620248200.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 05, 2021 at 02:04:44PM -0700, Boris Burkov wrote:
> generic/574 has tests for corrupting the merkle tree data stored by the
> filesystem. Since btrfs uses a different scheme for storing this data,
> the existing logic for corrupting it doesn't work out of the box. Adapt
> it to properly corrupt btrfs merkle items.
> 
> This test relies on the btrfs implementation of fsverity in the patches
> titled:
> btrfs: initial fsverity support
> btrfs: check verity for reads of inline extents and holes
> btrfs: fallback to buffered io for verity files
> 
> A fix for fiemap in the patch titled:
> btrfs: return whole extents in fiemap
> 
> and on btrfs-corrupt-block for corruption in the patches titled:
> btrfs-progs: corrupt generic item data with btrfs-corrupt-block
> btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  common/verity     | 18 ++++++++++++++++++
>  tests/generic/574 |  5 +++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/common/verity b/common/verity
> index d2c1ea24..1636e88b 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -315,6 +315,24 @@ _fsv_scratch_corrupt_merkle_tree()
>  		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
>  		_fsv_scratch_corrupt_bytes $file $offset
>  		;;
> +	btrfs)
> +		local ino=$(stat -c '%i' $file)
> +		_scratch_unmount
> +		local byte=""
> +		while read -n 1 byte; do
> +			if [ -z $byte ]; then
> +				break
> +			fi
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
> index 1e296618..e4370dae 100755
> --- a/tests/generic/574
> +++ b/tests/generic/574
> @@ -43,6 +43,11 @@ _scratch_mount
>  fsv_orig_file=$SCRATCH_MNT/file
>  fsv_file=$SCRATCH_MNT/file.fsv
>  
> +# utility needed for corrupting Merkle data itself in btrfs
> +if [ $FSTYP == "btrfs" ]; then
> +	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs_corrupt_block
> +fi

I don't think this is needed, as _require_scratch_verity() already did
this check.

Thanks,
Eryu

> +
>  setup_zeroed_file()
>  {
>  	local len=$1
> -- 
> 2.30.2
