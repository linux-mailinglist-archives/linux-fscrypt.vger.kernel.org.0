Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403765168DA
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 May 2022 01:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiEAXZu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 19:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiEAXZu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 19:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E955F5A;
        Sun,  1 May 2022 16:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC42361152;
        Sun,  1 May 2022 23:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7F4C385AA;
        Sun,  1 May 2022 23:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651447342;
        bh=Rkk1Gh6W3dr24/uRK0uggQYdg1OCwuRy8D6PFoJ0TVw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vCeQi5De0axC3YnCzWZYxaOm1vYM0/eac6h/vRmqe/h47zntqTViESOhRk2QG90/h
         6/5IKbFR50vkEpNidEqquZwzTm4txwj65a99/r3sB9P281Qm9x44/OZKObcPoJKzT0
         xP3X3we6PZIxsV4CevfHyrrUU2HAVYFO5kHXHP7geNUgAKr8VTbBqKEXf9GweewS4k
         dagw/gCa9PENMFz8mqMlr2A3Cxho/Zu0bo1yyCqCTfMUgKmnpxh24uqYPqnhRg6JLl
         5X16n5l8QzgQYY+17ToVI7nFZzxJg2GHdBf7vwMFGwwCMFu0kDnmg0dHUKU84q2pnM
         7z5NL4yxqKO8w==
Date:   Sun, 1 May 2022 16:22:18 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v9 2/5] common/verity: support btrfs in generic fsverity
 tests
Message-ID: <Ym8WKhTqoUhSCXjo@sol.localdomain>
References: <cover.1651012461.git.boris@bur.io>
 <3ac2f088ab31052659aa37a7e2f0821ef7b95e60.1651012461.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ac2f088ab31052659aa37a7e2f0821ef7b95e60.1651012461.git.boris@bur.io>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Apr 26, 2022 at 03:40:13PM -0700, Boris Burkov wrote:
> diff --git a/common/verity b/common/verity
> index d58cad90..8cde2737 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -3,6 +3,13 @@
>  #
>  # Functions for setting up and testing fs-verity
>  
> +. common/btrfs
> +# btrfs will return IO errors on corrupted data with or without fs-verity.
> +# to really test fs-verity, use nodatasum.
> +if [ "$FSTYP" == "btrfs" ]; then
> +	export MOUNT_OPTIONS="-o nodatasum"
> +fi

Shouldn't this append to MOUNT_OPTIONS rather than replacing it?

> diff --git a/tests/generic/574 b/tests/generic/574
> index 17fdea52..680cece3 100755
> --- a/tests/generic/574
> +++ b/tests/generic/574
> @@ -126,6 +126,41 @@ corruption_test()
>  	fi
>  }
>  
> +# xfs_io mread's output is parseable by xxd -r, except it has an extra space
> +# after the colon. Output the number of non zero characters in the parsed contents.
> +filter_mread() {
> +	sed 's/:  /: /' | xxd -r | sed 's/\x0//g' | wc -c
> +}
> +
> +# this expects to see stdout + stderr passed through filter_sigbus and filter_mread.
> +# Outputs "OK" on a bus error or 0 non-zero characters counted by mread.
> +filter_eof_block() {
> +	sed 's/^Bus error$/OK/' | sed 's/^0$/OK/'
> +}
> +
> +# some filesystems return zeros in the last block past EOF, regardless of
> +# their contents. Handle those with a special test that accepts either zeros
> +# or SIGBUS on an mmap+read of that block.
> +corrupt_eof_block_test() {
> +	local file_len=$1
> +	local zap_len=$2
> +	local page_aligned_eof=$(round_up_to_page_boundary $file_len)
> +	local eof_page_start=$((page_aligned_eof - $(get_page_size)))
> +	local corrupt_func=_fsv_scratch_corrupt_bytes

The corrupt_func variable is unnecessary.

> +	_fsv_scratch_begin_subtest "Corruption test: EOF block"
> +	setup_zeroed_file $file_len false
> +	cmp $fsv_file $fsv_orig_file
> +	echo "Corrupting bytes..."
> +	head -c $zap_len /dev/zero | tr '\0' X \
> +		| $corrupt_func $fsv_file $((file_len + 1))
> +
> +	echo "Validating corruption or zeros (reading eof block via mmap)..."
> +	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
> +		-c 'mmap -r $eof_page_start $(get_page_size)' \
> +		-c 'mread -v $eof_page_start $(get_page_size)'" \
> +		|& filter_mread | filter_sigbus | filter_eof_block
> +}
> +

This actually causes the test to stop checking for the string "Bus error"
because it sends the output through 'xxd -r' first, which turns anything that
isn't valid 'xxd' input into all zeroed bytes, which passes the test.  So
"Bus error" will still pass, but lots of other random strings will pass too.

Also, I don't think we can assume that the xxd program is available, as it's
part of the vim package.  This would be the first use of xxd in xfstests.

Instead, how about dumping the output to a file $tmp.out, then checking if
either of the following is true:

   - The output contains the string "Bus error".
   - The contents of the output matches that of the same xfs_io command executed
     on the same region of a file containing all zeroes.

Also, it might be a bit simpler to use $file_len as the $zap_offset (instead of
$file_len + 1), and just reading $zap_len bytes starting at $file_len.  The
mread doesn't need to be page aligned; only the mmap needs to be, and that can
just be from 0 to page_aligned_eof.  That would also avoid the page/block
ambiguity where the comments are talking about the "EOF block", but the code is
actually reading a whole page.

>  # Non-zeroed bytes in the final partial block beyond EOF should cause reads to
> -# fail too.  Such bytes would be visible via mmap().
> -corruption_test 130999 131000 72
> +# fail too.  Such bytes could be visible via mmap().
> +corrupt_eof_block_test 130999 72

The above comment is now outdated.  Maybe just remove it and improve the comment
above corrupt_eof_block_test().

- Eric
