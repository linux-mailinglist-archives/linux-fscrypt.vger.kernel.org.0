Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24305615C21
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 07:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiKBGSF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 02:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiKBGSE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 02:18:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD10625C5A;
        Tue,  1 Nov 2022 23:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB1FB820D0;
        Wed,  2 Nov 2022 06:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BF9C433C1;
        Wed,  2 Nov 2022 06:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667369881;
        bh=2OIjHvL54t1DXYOXYxp6qJOT614me6QcO9DL4rk9VrU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dU78BYohrAV0o2uZcHI1mnzDPyPziGY2J8TNpdf7qa+Akf5WnUHu5PJmHKL6z558Z
         LWA3SSiessnH5waINDt9RJSa4akWUhCMtqAaiQXXkyfWsnhnTeminjdIZgKTJ5L3FT
         40svmK4tGVUUMyRYktBwooTBoPD/gQccwMd0rmsi1lE2q7HDAnXVk4YVX7nhqjSjrc
         EQQL4aWLVojoXIvNwN4O1R4Fg+bGGakJ7p5iwntdFJSeGiYE3BYRj97GewN1VDXkaQ
         R2AC/KWUiGoHsWO84OPzKWvwG+1IwK1/+V22mMrOzUfWtY/kMEwAcFvRBo3Ha7IVJO
         5n7+wkh0payQQ==
Date:   Tue, 1 Nov 2022 23:17:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Chen <harperchen1110@gmail.com>
Subject: f2fs_empty_dir() can be extremely slow on malicious disk images
Message-ID: <Y2ILlpqFQVO9fH8B@sol.localdomain>
References: <CAO4mrfc3sbZVj3QOdAVFqrZp+mEuPQTtQCQsQy-07W_BEFqZ2Q@mail.gmail.com>
 <CAO4mrfexzxeYwAkvWGfg=tEiczUWarO6y68KFD9EG9qZtGejng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO4mrfexzxeYwAkvWGfg=tEiczUWarO6y68KFD9EG9qZtGejng@mail.gmail.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[+f2fs list and maintainers]
[changed subject from "INFO: task hung in fscrypt_ioctl_set_policy"]

On Mon, Oct 31, 2022 at 10:18:02PM +0800, Wei Chen wrote:
> Dear Linux developers,
> 
> Here is the link to the reproducers.
> 
> C reproducer: https://drive.google.com/file/d/1mduYsYuoOKemH3qkvpDQwnAHAaaLUp0Y/view?usp=share_link
> Syz reproducer:
> https://drive.google.com/file/d/1mu-_w7dy_562vWRlQvTRbcBjG4_G7b2L/view?usp=share_link
> 
> The bug persists in the latest commit, v5.15.76 (4f5365f77018). I hope
> it is helpful to you.
> 
> [ 1782.137186][   T30] INFO: task a.out:6910 blocked for more than 143 seconds.
> [ 1782.139217][   T30]       Not tainted 5.15.76 #5
> [ 1782.140388][   T30] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1782.142524][   T30] task:a.out           state:D stack:14296 pid:
> 6910 ppid:  6532 flags:0x00004004
> [ 1782.144799][   T30] Call Trace:
> [ 1782.145623][   T30]  <TASK>
> [ 1782.146316][   T30]  __schedule+0x3e8/0x1850
> [ 1782.152029][   T30]  ? mark_held_locks+0x49/0x70
> [ 1782.153533][   T30]  ? mark_held_locks+0x10/0x70
> [ 1782.154759][   T30]  ? __down_write_common.part.14+0x31f/0x7b0
> [ 1782.156159][   T30]  schedule+0x4e/0xe0
> [ 1782.158314][   T30]  __down_write_common.part.14+0x324/0x7b0
> [ 1782.159704][   T30]  ? fscrypt_ioctl_set_policy+0xe0/0x200
> [ 1782.161050][   T30]  fscrypt_ioctl_set_policy+0xe0/0x200
> [ 1782.162330][   T30]  __f2fs_ioctl+0x9d6/0x45e0
> [ 1782.163417][   T30]  f2fs_ioctl+0x64/0x240
> [ 1782.164404][   T30]  ? __f2fs_ioctl+0x45e0/0x45e0
> [ 1782.165554][   T30]  __x64_sys_ioctl+0xb6/0x100
> [ 1782.166662][   T30]  do_syscall_64+0x34/0xb0
> [ 1782.169947][   T30]  entry_SYSCALL_64_after_hwframe+0x61/0xcb

Well, the quality of this bug report has a lot to be desired (not on upstream
kernel, reproducer is full of totally irrelevant stuff, not sent to the mailing
list of the filesystem whose disk image is being fuzzed, etc.).  But what is
going on is that f2fs_empty_dir() doesn't consider the case of a directory with
an extremely large i_size on a malicious disk image.

Specifically, the reproducer mounts an f2fs image with a directory that has an
i_size of 14814520042850357248, then calls FS_IOC_SET_ENCRYPTION_POLICY on it.
That results in a call to f2fs_empty_dir() to check whether the directory is
empty.  f2fs_empty_dir() then iterates through all 3616826182336513 blocks the
directory allegedly contains to check whether any contain anything.  i_rwsem is
held during this, so anything else that tries to take it will hang.

I'll look into this more if needed, but Jaegeuk and Chao, do you happen to have
any ideas for how f2fs_empty_dir() should be fixed?  Is there an easy way to
just iterate through the blocks that are actually allocated?

- Eric
