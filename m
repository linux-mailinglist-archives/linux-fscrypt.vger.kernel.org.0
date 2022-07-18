Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879B95789BA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Jul 2022 20:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiGRSpE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jul 2022 14:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiGRSpD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jul 2022 14:45:03 -0400
X-Greylist: delayed 1337 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jul 2022 11:45:02 PDT
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F542A96A;
        Mon, 18 Jul 2022 11:45:01 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id A5AD680A78;
        Mon, 18 Jul 2022 14:45:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1658169901; bh=QS2ZPEL/XZt6kpKaBTHqMDgBo/XWb/MhaamT7pFmABI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gV4Q2j3l6SJ8ifot78d23gUZpXhLe7YxZ8h76u/tewwIdQb6gGkMW/qxccsznLImL
         sGfLvk/NjWKMbRmZLi2Id+lWX4bMmkDGhk7f5rbaOEnzQRhJ+KrFx9ouP4dFaX6cNs
         ynJ4XAqW+xz6Mm7qOMGvoHkMYrRfzVaF0OvPZiqGHzcxJewFxPLFpDUFDCKGrquCSR
         y9eHYKjJIz0VIktepPbqolsjnNMCnYUixeYqgf9LpIdpUJe9l7gAUPmk6L9IvSGF/R
         M/0rbDEOrAR5SbhIf7Ifad+jr+eHCfxqMIgpuVsL0KoeLGGHpmVSPScRYxgvN2ILqP
         fdJxjzhbOwLDw==
MIME-Version: 1.0
Date:   Mon, 18 Jul 2022 14:45:01 -0400
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Eric Biggers <ebiggers@google.com>,
        Josef Bacik <josefbacik@toxicpanda.com>
Subject: Re: [PATCH v10 2/5] common/verity: support btrfs in generic fsverity
 tests
In-Reply-To: <727d2656f4c543fd8a50e0b4de3246d37d3e039d.1657916662.git.boris@bur.io>
References: <cover.1657916662.git.boris@bur.io>
 <727d2656f4c543fd8a50e0b4de3246d37d3e039d.1657916662.git.boris@bur.io>
Message-ID: <da5f789371ea1b45826f8dd31189cb32@dorminy.me>
X-Sender: sweettea-kernel@dorminy.me
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 2022-07-15 16:31, Boris Burkov wrote:
> generic/572-579 have tests for fsverity. Now that btrfs supports
> fsverity, make these tests function as well. For a majority of the 
> tests
> that pass, simply adding the case to mkfs a btrfs filesystem with no
> extra options is sufficient.
> 
> However, generic/574 has tests for corrupting the merkle tree itself.
> Since btrfs uses a different scheme from ext4 and f2fs for storing this
> data, the existing logic for corrupting it doesn't work out of the box.
> Adapt it to properly corrupt btrfs merkle items.
> 
> 576 does not run because btrfs does not support transparent encryption.
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
>  common/btrfs          |  5 +++++
>  common/config         |  1 +
>  common/verity         | 32 ++++++++++++++++++++++++++++++++
>  tests/generic/574     | 37 ++++++++++++++++++++++++++++++++++---
>  tests/generic/574.out | 13 ++++---------
>  5 files changed, 76 insertions(+), 12 deletions(-)
> 
> diff --git a/common/btrfs b/common/btrfs
> index 14ad890e..bd2639bf 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -580,3 +580,8 @@ _btrfs_buffered_read_on_mirror()
>  		:
>  	done
>  }
> +
> +_require_btrfs_corrupt_block()
> +{
> +	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs-corrupt-block
> +}
> diff --git a/common/config b/common/config
> index de3aba15..c30eec6d 100644
> --- a/common/config
> +++ b/common/config
> @@ -297,6 +297,7 @@ export BTRFS_UTIL_PROG=$(type -P btrfs)
>  export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
>  export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
>  export BTRFS_TUNE_PROG=$(type -P btrfstune)
> +export BTRFS_CORRUPT_BLOCK_PROG=$(type -P btrfs-corrupt-block)
>  export XFS_FSR_PROG=$(type -P xfs_fsr)
>  export MKFS_NFS_PROG="false"
>  export MKFS_CIFS_PROG="false"
> diff --git a/common/verity b/common/verity
> index d58cad90..f9ccf2ff 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -3,6 +3,17 @@
>  #
>  # Functions for setting up and testing fs-verity
> 
> +. common/btrfs

Only a tiny thing: do you need this include? I think all the 
btrfs-specific stuff you're adding is behind a FSTYP == btrfs check, so 
I think you could get away without having the include?

> +# btrfs will return IO errors on corrupted data with or without 
> fs-verity.
> +# to really test fs-verity, use nodatasum.
> +if [ "$FSTYP" == "btrfs" ]; then
> +        if [ -z $MOUNT_OPTIONS ]; then
> +                export MOUNT_OPTIONS="-o nodatasum"
> +        else
> +                export MOUNT_OPTIONS+=" -o nodatasum"
> +        fi
> +fi
> +
>  _require_scratch_verity()
>  {
>  	_require_scratch
> @@ -145,6 +156,9 @@ _require_fsverity_dump_metadata()
>  _require_fsverity_corruption()
>  {
>  	_require_xfs_io_command "fiemap"
> +	if [ $FSTYP == "btrfs" ]; then
> +		_require_btrfs_corrupt_block
> +	fi
>  }
> 
>  _scratch_mkfs_verity()
> @@ -153,6 +167,9 @@ _scratch_mkfs_verity()
>  	ext4|f2fs)
>  		_scratch_mkfs -O verity
>  		;;
> +	btrfs)
> +		_scratch_mkfs
> +		;;
>  	*)
>  		_notrun "No verity support for $FSTYP"
>  		;;
> @@ -314,6 +331,21 @@ _fsv_scratch_corrupt_merkle_tree()
>  		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
>  		_fsv_scratch_corrupt_bytes $file $offset
>  		;;
> +	btrfs)
> +		local ino=$(stat -c '%i' $file)
> +		_scratch_unmount
> +		local byte=""
> +		while read -n 1 byte; do
> +			local ascii=$(printf "%d" "'$byte'")
> +			# This command will find a Merkle tree item for the inode (-I 
> $ino,37,0)
> +			# in the default filesystem tree (-r 5) and corrupt one byte (-b 1) 
> at
> +			# $offset (-o $offset) with the ascii representation of the byte we 
> read
> +			# (-v $ascii)
> +			$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v $ascii -o $offset
> -b 1 $SCRATCH_DEV
> +			(( offset += 1 ))
> +		done
> +		_scratch_mount
> +		;;
>  	*)
>  		_fail "_fsv_scratch_corrupt_merkle_tree() unimplemented on $FSTYP"
>  		;;
> diff --git a/tests/generic/574 b/tests/generic/574
> index 17fdea52..5ba4be7e 100755
> --- a/tests/generic/574
> +++ b/tests/generic/574
> @@ -126,6 +126,39 @@ corruption_test()
>  	fi
>  }
> 
> +# Reading the last block of the file with mmap is tricky, so we need 
> to be
> +# a bit careful. Some filesystems read the last block in full, while 
> others
> +# return zeros in the last block past EOF, regardless of the contents 
> on
> +# disk. In the former, corruption should be detected and result in 
> SIGBUS,
> +# while in the latter we would expect zeros past EOF, but no error.
> +corrupt_eof_block_test() {
> +	local file_len=$1
> +	local zap_len=$2
> +	local page_aligned_eof=$(round_up_to_page_boundary $file_len)
> +	_fsv_scratch_begin_subtest "Corruption test: EOF block"
> +	setup_zeroed_file $file_len false
> +	cmp $fsv_file $fsv_orig_file
> +	echo "Corrupting bytes..."
> +	head -c $zap_len /dev/zero | tr '\0' X \
> +		| _fsv_scratch_corrupt_bytes $fsv_file $file_len
> +
> +	echo "Reading eof block via mmap into a temporary file..."
> +	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
> +		-c 'mmap -r 0 $page_aligned_eof' \
> +		-c 'mread -v $file_len $zap_len'" \
> +		|& filter_sigbus >$tmp.eof_block_read 2>&1
> +
> +	head -c $file_len /dev/zero > $tmp.zero_cmp_file
> +	$XFS_IO_PROG -r $tmp.zero_cmp_file \
> +		-c "mmap -r 0 $page_aligned_eof" \
> +		-c "mread -v $file_len $zap_len" >$tmp.eof_zero_read
> +
> +	echo "Checking for SIGBUS or zeros..."
> +	<$tmp.eof_block_read grep -q -e '^Bus error$' \
> +		|| diff $tmp.eof_block_read $tmp.eof_zero_read \
> +		&& echo "OK"
> +}
> +
>  # Note: these tests just overwrite some bytes without checking their 
> original
>  # values.  Therefore, make sure to overwrite at least 5 or so bytes, 
> to make it
>  # nearly guaranteed that there will be a change -- even when the test 
> file is
> @@ -136,9 +169,7 @@ corruption_test 131072 4091 5
>  corruption_test 131072 65536 65536
>  corruption_test 131072 131067 5
> 
> -# Non-zeroed bytes in the final partial block beyond EOF should cause 
> reads to
> -# fail too.  Such bytes would be visible via mmap().
> -corruption_test 130999 131000 72
> +corrupt_eof_block_test 130999 72
> 
>  # Merkle tree corruption.
>  corruption_test 200000 100 10 true
> diff --git a/tests/generic/574.out b/tests/generic/574.out
> index 3c08d3e8..d40d1263 100644
> --- a/tests/generic/574.out
> +++ b/tests/generic/574.out
> @@ -56,17 +56,12 @@ Bus error
>  Validating corruption (reading just corrupted part via mmap)...
>  Bus error
> 
> -# Corruption test: file_len=130999 zap_offset=131000 zap_len=72
> +# Corruption test: EOF block
>  f5cca0d7fbb8b02bc6118a9954d5d306  SCRATCH_MNT/file.fsv
>  Corrupting bytes...
> -Validating corruption (reading full file)...
> -md5sum: SCRATCH_MNT/file.fsv: Input/output error
> -Validating corruption (direct I/O)...
> -dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
> -Validating corruption (reading full file via mmap)...
> -Bus error
> -Validating corruption (reading just corrupted part via mmap)...
> -Bus error
> +Reading eof block via mmap into a temporary file...
> +Checking for SIGBUS or zeros...
> +OK
> 
>  # Corruption test: file_len=200000 zap_offset=100 (in Merkle tree) 
> zap_len=10
>  4a1e4325031b13f933ac4f1db9ecb63f  SCRATCH_MNT/file.fsv
