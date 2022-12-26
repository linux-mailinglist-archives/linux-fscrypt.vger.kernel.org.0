Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E469F656017
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Dec 2022 06:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiLZFVj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Dec 2022 00:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiLZFVi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Dec 2022 00:21:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCE3CC6;
        Sun, 25 Dec 2022 21:21:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B87060C53;
        Mon, 26 Dec 2022 05:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DA4C433D2;
        Mon, 26 Dec 2022 05:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672032096;
        bh=akxa9sPtIV6XYFZXqCCzrmSw43cnjtPU3mSdRTwtlRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z7RbQMF2QVlM9E66spAjuRTDNUMpVyZnXlS1/yiCJ3AKcjwOM7E3cO0MdPyYb0/XT
         DMXHcVnKgTsozn2c/g/+BHZDL9eqIBrereoWuoku02mMIxUCnJyoZp8YUV1Sh1VefX
         4pYDN1jH2pzk+aAZ7YEyrydEIX9Ik+K07y+mwfXhZUwHbvn7c24uJXYXMTJap82X7t
         UUnpjMoRpEdGqv+suFZtXXbYfg9NAdlKPk6LH7wGUHBERq+mr4d8EU3SOBTsKf8cg3
         ercNXTLqThsDvEYww9lGESsvablKeRqyZMLl0o32KYfaVT/38ZuijkoNIo9rXDuQ8Q
         dZ0TnShQ1i6XA==
Date:   Sun, 25 Dec 2022 21:21:34 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 08/10] generic/574: test multiple Merkle tree block
 sizes
Message-ID: <Y6kvXs33MmxVovNO@sol.localdomain>
References: <20221223010554.281679-1-ebiggers@kernel.org>
 <20221223010554.281679-9-ebiggers@kernel.org>
 <20221225124600.faouh6a7suhq2wuu@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221225124600.faouh6a7suhq2wuu@zlang-mailbox>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Dec 25, 2022 at 08:46:00PM +0800, Zorro Lang wrote:
> > +	# Reading the full file via mmap should fail.
> >  	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
> >  		-c 'mmap -r 0 $page_aligned_eof' \
> > -		-c 'mread 0 $file_len'" |& filter_sigbus
> > +		-c 'mread 0 $file_len'" >/dev/null 2>$tmp.out
> > +	if ! grep -q 'Bus error' $tmp.out; then
> > +		echo "Didn't see SIGBUS when reading file via mmap"
> 
> Hmm... will sigbus error really be output to stderr? From a testing, the
> generic/574 fails as:
> 
> # ./check -s simpledev generic/574
> SECTION       -- simpledev
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 xx-xxxxxx-xxx 6.1.0-rc3 #5 SMP PREEMPT_DYNAMIC Tue Nov  1 01:08:52 CST 2022
> MKFS_OPTIONS  -- -F /dev/sdb
> MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:root_t:s0 /dev/sdb /mnt/scratch
> 
> generic/574       - output mismatch (see /root/git/xfstests/results//simpledev/generic/574.out.bad)
>     --- tests/generic/574.out   2022-12-25 20:02:41.609104749 +0800
>     +++ /root/git/xfstests/results//simpledev/generic/574.out.bad       2022-12-25 20:21:57.430719504 +0800
>     @@ -1,6 +1,32 @@
>      QA output created by 574
>      
>      # Testing block_size=FSV_BLOCK_SIZE
>     +/root/git/xfstests/tests/generic/574: line 69: 1949533 Bus error               (core dumped) bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file            -c 'mmap -r 0 $page_aligned_eof'               -c 'mread 0 $file_len'" > /dev/null 2> $tmp.out
>     +Didn't see SIGBUS when reading file via mmap

This test passes for me both before and after this patch series.

Both before and after, the way this is supposed to work is that in:

	bash -c "trap '' SIGBUS; command_that_exits_with_sigbus"

... bash should print "Bus error" to stderr due to
'command_that_exits_with_sigbus'.  That "Bus error" is then redirected.  Before
it was redirected to a pipeline; after it is redirected to a file.

I think what's happening is that the version of bash your system has is not
forking before exec'ing 'command_that_exits_with_sigbus'.  As a result, "Bus
error" is printed by the *parent* bash process instead, skipping any redirection
in the shell script.

Apparently skipping fork is a real thing in bash, and different versions of bash
have had subtly different conditions for enabling it.  So this seems plausible.

Adding an extra command after 'command_that_exits_with_sigbus' should fix this:

	bash -c "trap '' SIGBUS; command_that_exits_with_sigbus; true"

The joy of working with a shell scripting system where everyone has different
versions of everything installed...

- Eric
