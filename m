Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9B3651AFB
	for <lists+linux-fscrypt@lfdr.de>; Tue, 20 Dec 2022 07:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiLTG5A (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 20 Dec 2022 01:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiLTG47 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 20 Dec 2022 01:56:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F9C95BC
        for <linux-fscrypt@vger.kernel.org>; Mon, 19 Dec 2022 22:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671519372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c9+Nr/9vTNFEp2yGiFd4gGItFfceJvuZ/1DBexQA1hk=;
        b=gMhFEqB4watnt8Kj+8y9l1cQo2tARtYLvA/v0XVHH2ZejibXmSbfDQqtIDmhZJvg5nyatc
        HAtNEYVmDHVk2SmI8VHRSKiwNFR2mSHjoEkOGolBx6g9G3K267MNLTnYNHYATUOp5aMKcx
        M7VPCBAkuE3ihebBkKwWWGqeMgqgBhI=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-168-gqAJKj6NPcypqhEpTRxoAA-1; Tue, 20 Dec 2022 01:56:10 -0500
X-MC-Unique: gqAJKj6NPcypqhEpTRxoAA-1
Received: by mail-pg1-f200.google.com with SMTP id 23-20020a630017000000b0048d84f2cbbeso2125839pga.9
        for <linux-fscrypt@vger.kernel.org>; Mon, 19 Dec 2022 22:56:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9+Nr/9vTNFEp2yGiFd4gGItFfceJvuZ/1DBexQA1hk=;
        b=UqPWq182snU7A5TW0rMnBvHJGcXFM9dYMWgE3BYPzbIpMdgKc1pNdAkg3KX7J2uKJT
         s6xv7lmyW+EbSPV0XRd/p/Gwo5mm8yuEy2m6BvyFKL22OEYs48aylQ+8Z6SIBIN8ekF8
         6IpQ4EnnjyjgODBG9JgTiBYRbL7jQDweI3YBm7rHu2JO45TDjnI8gxA8MnrmGAuWSQCq
         k6XcDdvT1hLhwBuVfNF6WBTR+8i+yVrFSWPiiEJHGfxNVLgFCqnEhRxpSogr8epgFnvh
         ZwHwLII2VftfnB2KNrRvpOUUThWbbd0fqjoEqX2vH2RBzItJOjSFDIXrYARCfiqr66Ll
         yq3w==
X-Gm-Message-State: AFqh2kr/XKwdgiZU03X9ctytP0kEORDSCx6ajAuTtlPLgDzo2KAJ8kgj
        CA7+ky2Q1iHvsDRbFc7iHXkFky/2waiQugseJ2IVmnQwuNBulpUKY9sMkbAtortZfn+lMjg8suE
        F5WV5P9lEfVj6GaNf4l2HbzaZow==
X-Received: by 2002:a17:90a:c301:b0:223:acc1:837e with SMTP id g1-20020a17090ac30100b00223acc1837emr10669857pjt.31.1671519369245;
        Mon, 19 Dec 2022 22:56:09 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsEEdEQ8FUa+OclWLgc0aZCyGRAhx8ydiPiXuopFoLoK0ZenxLgUdYOubXu7sy2dBitC8I1ig==
X-Received: by 2002:a17:90a:c301:b0:223:acc1:837e with SMTP id g1-20020a17090ac30100b00223acc1837emr10669837pjt.31.1671519368786;
        Mon, 19 Dec 2022 22:56:08 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h15-20020a17090a130f00b0021900ba8eeesm10438707pja.2.2022.12.19.22.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 22:56:08 -0800 (PST)
Date:   Tue, 20 Dec 2022 14:56:04 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 09/10] generic/624: test multiple Merkle tree block sizes
Message-ID: <20221220065604.eorvm6nlzamh6tyt@zlang-mailbox>
References: <20221211070704.341481-1-ebiggers@kernel.org>
 <20221211070704.341481-10-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221211070704.341481-10-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Dec 10, 2022 at 11:07:02PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Instead of only testing 4K Merkle tree blocks, test FSV_BLOCK_SIZE, and
> also other sizes if they happen to be supported.  This allows this test
> to run in cases where it couldn't before and improves test coverage in
> cases where it did run before.
> 
> This required reworking the test to compute the expected digests using
> the 'fsverity digest' command, instead of relying on .out file
> comparisons.  (There isn't much downside to this, since comparison to
> known-good file digests already happens in generic/575.  So if both the
> kernel and fsverity-utils were to be broken in the same way, generic/575
> would detect it.  generic/624 serves a different purpose.)
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  common/verity         |  11 ++++
>  tests/generic/624     | 119 ++++++++++++++++++++++++++++++------------
>  tests/generic/624.out |  15 ++----
>  3 files changed, 101 insertions(+), 44 deletions(-)
> 
> diff --git a/common/verity b/common/verity
> index b88e839b..36a0f7d1 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -263,6 +263,17 @@ _fsv_measure()
>          $FSVERITY_PROG measure "$@" | awk '{print $1}'
>  }
>  
> +_fsv_digest()
> +{
> +	local args=("$@")
> +	# If the caller didn't explicitly specify a Merkle tree block size, then
> +	# use FSV_BLOCK_SIZE.
> +	if ! [[ " $*" =~ " --block-size" ]]; then
> +		args+=("--block-size=$FSV_BLOCK_SIZE")
> +	fi
> +        $FSVERITY_PROG digest "${args[@]}" | awk '{print $1}'
> +}
> +
>  _fsv_sign()
>  {
>  	local args=("$@")
> diff --git a/tests/generic/624 b/tests/generic/624
> index 7c447289..87a1e9d2 100755
> --- a/tests/generic/624
> +++ b/tests/generic/624
> @@ -24,48 +24,99 @@ _cleanup()
>  _supported_fs generic
>  _require_scratch_verity
>  _disable_fsverity_signatures
> -# For the output of this test to always be the same, it has to use a specific
> -# Merkle tree block size.
> -if [ $FSV_BLOCK_SIZE != 4096 ]; then
> -	_notrun "4096-byte verity block size not supported on this platform"
> -fi
> +fsv_orig_file=$SCRATCH_MNT/file
> +fsv_file=$SCRATCH_MNT/file.fsv
>  
>  _scratch_mkfs_verity &>> $seqres.full
>  _scratch_mount
> -
> -echo -e "\n# Creating a verity file"
> -fsv_file=$SCRATCH_MNT/file
> -# Always use the same file contents, so that the output of the test is always
> -# the same.  Also use a file that is large enough to have multiple Merkle tree
> -# levels, so that the test verifies that the blocks are returned in the expected
> -# order.  A 1 MB file with SHA-256 and a Merkle tree block size of 4096 will
> -# have 3 Merkle tree blocks (3*4096 bytes): two at level 0 and one at level 1.
> -head -c 1000000 /dev/zero > $fsv_file
> -merkle_tree_size=$((3 * FSV_BLOCK_SIZE))
> -fsverity_descriptor_size=256
> -_fsv_enable $fsv_file --salt=abcd
> +_fsv_create_enable_file $fsv_file
>  _require_fsverity_dump_metadata $fsv_file
> -_fsv_measure $fsv_file
>  
> -echo -e "\n# Dumping Merkle tree"
> -_fsv_dump_merkle_tree $fsv_file | sha256sum
> +# Test FS_IOC_READ_VERITY_METADATA on a file that uses the given Merkle tree
> +# block size.
> +test_block_size()
> +{
> +	local block_size=$1
> +	local digest_size=32 # assuming SHA-256
> +	local i
> +
> +	# Create the file.  Make the file size big enough to result in multiple
> +	# Merkle tree levels being needed.  The following expression computes a
> +	# file size that needs 2 blocks at level 0, and thus 1 block at level 1.
> +	local file_size=$((block_size * (2 * (block_size / digest_size))))
> +	head -c $file_size /dev/zero > $fsv_orig_file
> +	local tree_params=("--salt=abcd" "--block-size=$block_size")
> +	cp $fsv_orig_file $fsv_file
> +	_fsv_enable $fsv_file "${tree_params[@]}"
> +
> +	# Use the 'fsverity digest' command to compute the expected Merkle tree,
> +	# descriptor, and file digest.
> +	#
> +	# Ideally we'd just hard-code expected values into the .out file and
> +	# echo the actual values.  That doesn't quite work here, since all these
> +	# values depend on the Merkle tree block size, and the Merkle tree block
> +	# sizes that are supported (and thus get tested here) vary.  Therefore,
> +	# we calculate the expected values in userspace with the help of
> +	# 'fsverity digest', then do explicit comparisons with them.  This works
> +	# fine as long as fsverity-utils and the kernel don't get broken in the
> +	# same way, in which case generic/575 should detect the problem anyway.
> +	local expected_file_digest=$(_fsv_digest $fsv_orig_file \
> +		"${tree_params[@]}" \
> +		--out-merkle-tree=$tmp.merkle_tree.expected \
> +		--out-descriptor=$tmp.descriptor.expected)
> +	local merkle_tree_size=$(_get_filesize $tmp.merkle_tree.expected)
> +	local descriptor_size=$(_get_filesize $tmp.descriptor.expected)
>  
> -echo -e "\n# Dumping Merkle tree (in chunks)"
> -# The above test may get the whole tree in one read, so also try reading it in
> -# chunks.
> -for (( i = 0; i < merkle_tree_size; i += 997 )); do
> -	_fsv_dump_merkle_tree $fsv_file --offset=$i --length=997
> -done | sha256sum
> +	# 'fsverity measure' should return the expected file digest.
> +	local actual_file_digest=$(_fsv_measure $fsv_file)
> +	if [ "$actual_file_digest" != "$expected_file_digest" ]; then
> +		echo "Measure returned $actual_file_digest but expected $expected_file_digest"
> +	fi
>  
> -echo -e "\n# Dumping descriptor"
> -# Note that the hash that is printed here should be the same hash that was
> -# printed by _fsv_measure above.
> -_fsv_dump_descriptor $fsv_file | sha256sum
> +	# Test dumping the Merkle tree.
> +	_fsv_dump_merkle_tree $fsv_file > $tmp.merkle_tree.actual
> +	if ! cmp $tmp.merkle_tree.expected $tmp.merkle_tree.actual; then
> +		echo "Dumped Merkle tree didn't match"
> +	fi
> +
> +	# Test dumping the Merkle tree in chunks.
> +	for (( i = 0; i < merkle_tree_size; i += 997 )); do
> +		_fsv_dump_merkle_tree $fsv_file --offset=$i --length=997
> +	done > $tmp.merkle_tree.actual
> +	if ! cmp $tmp.merkle_tree.expected $tmp.merkle_tree.actual; then
> +		echo "Dumped Merkle tree (in chunks) didn't match"
> +	fi
> +
> +	# Test dumping the descriptor.
> +	_fsv_dump_descriptor $fsv_file > $tmp.descriptor.actual
> +	if ! cmp $tmp.descriptor.expected $tmp.descriptor.actual; then
> +		echo "Dumped descriptor didn't match"
> +	fi
> +
> +	# Test dumping the descriptor in chunks.
> +	for (( i = 0; i < descriptor_size; i += 13 )); do
> +		_fsv_dump_descriptor $fsv_file --offset=$i --length=13
> +	done > $tmp.descriptor.actual
> +	if ! cmp $tmp.descriptor.expected $tmp.descriptor.actual; then
> +		echo "Dumped descriptor (in chunks) didn't match"
> +	fi
> +}
>  
> -echo -e "\n# Dumping descriptor (in chunks)"
> -for (( i = 0; i < fsverity_descriptor_size; i += 13 )); do
> -	_fsv_dump_descriptor $fsv_file --offset=$i --length=13
> -done | sha256sum
> +# Always test FSV_BLOCK_SIZE.  Also test some other block sizes if they happen
> +# to be supported.
> +_fsv_scratch_begin_subtest "Testing FS_IOC_READ_VERITY_METADATA with block_size=FSV_BLOCK_SIZE"
> +test_block_size $FSV_BLOCK_SIZE
> +for block_size in 1024 4096 16384 65536; do
> +	_fsv_scratch_begin_subtest "Testing FS_IOC_READ_VERITY_METADATA with block_size=$block_size"
> +	if (( block_size == FSV_BLOCK_SIZE )); then
> +		continue
> +	fi
> +	if ! _fsv_can_enable $fsv_file --block-size=$block_size; then
> +		echo "block_size=$block_size is unsupported" >> $seqres.full
> +		continue

If a block size isn't supported, e.g. 1024. Then this case trys to skip that
test, but it'll break golden image, due to the .out file contains each line
of:
  Testing FS_IOC_READ_VERITY_METADATA with block_size=1024/4096/16384/65536

Do you expect that failure, or we shouldn't fail on that?

Thanks,
Zorro

> +	fi
> +	test_block_size $block_size
> +done
>  
>  # success, all done
>  status=0
> diff --git a/tests/generic/624.out b/tests/generic/624.out
> index 912826d3..97d5691a 100644
> --- a/tests/generic/624.out
> +++ b/tests/generic/624.out
> @@ -1,16 +1,11 @@
>  QA output created by 624
>  
> -# Creating a verity file
> -sha256:11e4f886bf2d70a6ef3a8b6ce8e8c62c9e5d3263208b9f120ae46791f124be73
> +# Testing FS_IOC_READ_VERITY_METADATA with block_size=FSV_BLOCK_SIZE
>  
> -# Dumping Merkle tree
> -db88cdad554734cd648a1bfbb5be7f86646c54397847aab0b3f42a28829fed17  -
> +# Testing FS_IOC_READ_VERITY_METADATA with block_size=1024
>  
> -# Dumping Merkle tree (in chunks)
> -db88cdad554734cd648a1bfbb5be7f86646c54397847aab0b3f42a28829fed17  -
> +# Testing FS_IOC_READ_VERITY_METADATA with block_size=4096
>  
> -# Dumping descriptor
> -11e4f886bf2d70a6ef3a8b6ce8e8c62c9e5d3263208b9f120ae46791f124be73  -
> +# Testing FS_IOC_READ_VERITY_METADATA with block_size=16384
>  
> -# Dumping descriptor (in chunks)
> -11e4f886bf2d70a6ef3a8b6ce8e8c62c9e5d3263208b9f120ae46791f124be73  -
> +# Testing FS_IOC_READ_VERITY_METADATA with block_size=65536
> -- 
> 2.38.1
> 

