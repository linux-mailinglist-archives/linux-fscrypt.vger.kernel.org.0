Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CCD5094BE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 03:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383667AbiDUBpK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 Apr 2022 21:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357358AbiDUBpJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 Apr 2022 21:45:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB25765E;
        Wed, 20 Apr 2022 18:42:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7752761AE3;
        Thu, 21 Apr 2022 01:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6EEC385A1;
        Thu, 21 Apr 2022 01:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650505340;
        bh=ul1Udr04xMg38GJAsG+k+SVe40hU0hrxodm0nmtCHlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X7Dt0fsMsvIBWGdyS0gOJN8k3WQpPe00FO4YjS8Gl5VmCtusJkwsQzIwmUC4lUI6R
         xV/lUyMSA6ZKuRVDT36iZFyYDZMdb4I+d++/FUF13Z3xVC76bPQf4FDzz5atI4KWai
         JGZIRY/fNVsVe9yMOGVzj9SALS9cEpLh51+05puDdHz8fQ57sMGOp8//DokpO7Q70I
         Po/2dp999OHq/rITVHsw3X2jxXHkFGblxZuMJ/8kGU2UMH6qtq2bKTaA+cAPy7lEoB
         vK75T+EC4lDlU94EFM0qv7+YWpB0O83gsCSPwoA+L05nIoy7/6NR1H4Dr9N4L3vnau
         P1jzptAzrMKFg==
Date:   Thu, 21 Apr 2022 01:42:18 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     syzbot <syzbot+1a748d0007eeac3ab079@syzkaller.appspotmail.com>
Cc:     jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [syzbot] possible deadlock in fscrypt_initialize
Message-ID: <YmC2epeJNChYxWB3@gmail.com>
References: <00000000000070395e05dd1fb4d7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000070395e05dd1fb4d7@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Apr 20, 2022 at 06:05:24PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    90ea17a9e27b Merge tag 'scsi-fixes' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16bf09d0f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ac042ae170e2c50f
> dashboard link: https://syzkaller.appspot.com/bug?extid=1a748d0007eeac3ab079
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1a748d0007eeac3ab079@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.18.0-rc2-syzkaller-00291-g90ea17a9e27b #0 Not tainted
> ------------------------------------------------------
> syz-executor.0/3694 is trying to acquire lock:
> ffffffff8bf36428 (fscrypt_init_mutex){+.+.}-{3:3}, at: fscrypt_initialize+0x3c/0xa0 fs/crypto/crypto.c:324
> 
> but task is already holding lock:
> ffff8880430c8990 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfb4/0x14a0 fs/jbd2/transaction.c:461

This is a regression from a while back from the ext4 fast_commit changes,
specifically commit a80f7fcf1867 ("ext4: fixup ext4_fc_track_* functions'
signature") which extended the scope of the transaction in ext4_unlink() too
far.  It's been on my TODO list to fix, along with the reports of fast_commit
and encryption not working together.  I'll try to get to it soon.

- Eric
