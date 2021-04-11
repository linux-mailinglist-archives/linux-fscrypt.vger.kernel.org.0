Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4979435B410
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Apr 2021 14:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhDKMTv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Apr 2021 08:19:51 -0400
Received: from out20-86.mail.aliyun.com ([115.124.20.86]:37421 "EHLO
        out20-86.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhDKMTv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Apr 2021 08:19:51 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09471063|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.208122-0.00564878-0.786229;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047201;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.JyJ0sD8_1618143572;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.JyJ0sD8_1618143572)
          by smtp.aliyun-inc.com(10.147.40.44);
          Sun, 11 Apr 2021 20:19:32 +0800
Date:   Sun, 11 Apr 2021 20:19:32 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 2/3] generic/574: corrupt btrfs merkle tree data
Message-ID: <YHLpVNiPVXVPM1oP@desktop>
References: <cover.1617908086.git.boris@bur.io>
 <4429f6365c3250efe9bf7bc0a1a22e642b149f61.1617908086.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4429f6365c3250efe9bf7bc0a1a22e642b149f61.1617908086.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 08, 2021 at 11:57:50AM -0700, Boris Burkov wrote:
> generic/574 has tests for corrupting the merkle tree data stored by the
> filesystem. Since btrfs uses a different scheme for storing this data,
> the existing logic for corrupting it doesn't work out of the box. Adapt
> it to properly corrupt btrfs merkle items.
> 
> Note that there is a bit of a kludge here: since btrfs_corrupt_block
> doesn't handle streaming corruption bytes from stdin (I could change
> that, but it feels like overkill for this purpose), I just read the
> first corruption byte and duplicate it for the desired length. That is
> how the test is using the interface in practice, anyway.
> 
> This relies on the following kernel patch for btrfs verity support:
> <btrfs-verity-patch>
> And the following btrfs-progs patch for btrfs_corrupt_block support:
> <btrfs-corrupt-block-patch>
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  common/verity | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/common/verity b/common/verity
> index d2c1ea24..fdd05783 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -3,8 +3,7 @@
>  #
>  # Functions for setting up and testing fs-verity
>  
> -_require_scratch_verity()
> -{
> +_require_scratch_verity() {

No need to change this.

>  	_require_scratch
>  	_require_command "$FSVERITY_PROG" fsverity
>  
> @@ -315,6 +314,18 @@ _fsv_scratch_corrupt_merkle_tree()
>  		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
>  		_fsv_scratch_corrupt_bytes $file $offset
>  		;;
> +	btrfs)
> +		ino=$(ls -i $file | awk '{print $1}')

stat -c %i $1

And declare local variables with local.

> +		sync

Why a system wide sync is needed here?

> +		cat > $tmp.bytes

I think this cat would just hang there.

> +		sz=$(_get_filesize $tmp.bytes)
> +		read -n 1 byte < $tmp.bytes
> +		ascii=$(printf "%d" "'$byte'")
> +		_scratch_unmount
> +		$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v $ascii -o $offset -b $sz $SCRATCH_DEV

It'd be better to explain this command in comments.

> +		sync

Again, is this sync really needed?

Thanks,
Eryu

> +		_scratch_mount
> +		;;
>  	*)
>  		_fail "_fsv_scratch_corrupt_merkle_tree() unimplemented on $FSTYP"
>  		;;
> -- 
> 2.30.2
