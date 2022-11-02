Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED0F6171A6
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Nov 2022 00:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKBXTO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 19:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiKBXTM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 19:19:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305DDF6E;
        Wed,  2 Nov 2022 16:19:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2FACB823C1;
        Wed,  2 Nov 2022 23:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D248C433D6;
        Wed,  2 Nov 2022 23:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667431146;
        bh=HupAuevPbecozuXcQzHBcqC7vZmHybBz2TUHcNzWFSQ=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=PWgSFY447bxe7G/5f6cRhi+ot9S7DMiwug6QTMZa7uI0x0trihSeKdywlWF9mYTAj
         HrdNOJ7AYt3sMRej1IAVswWrvxzfWwTKrn+dpD+YlNXhR60lbQDqAk5gzoxoOIecee
         DMjdSb5OwWuBjfnZJz90P9GtfM2gKw+Km6i0EdKEgSg/njX55j0oWe8/a0t8xZ2CFu
         z6F7XhpWxh2SaBtm7PBnZw32KzDUVO0DibvQq7IE5r5mKFNEneFi36xoPbeLIVWD1H
         XorPHlhowG7BC0iJSg/8QaBk6vY5YNK4LQszSVj9MjZ7y4BJ1zeitjIFDPmLA0YBg2
         zqV7F/UjSCxeA==
Message-ID: <536944df-a0ae-1dd8-148f-510b476e1347@kernel.org>
Date:   Thu, 3 Nov 2022 07:19:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [f2fs-dev] f2fs_empty_dir() can be extremely slow on malicious
 disk images
Content-Language: en-US
From:   Chao Yu <chao@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Wei Chen <harperchen1110@gmail.com>, linux-fscrypt@vger.kernel.org,
        tytso@mit.edu, linux-kernel@vger.kernel.org
References: <CAO4mrfc3sbZVj3QOdAVFqrZp+mEuPQTtQCQsQy-07W_BEFqZ2Q@mail.gmail.com>
 <CAO4mrfexzxeYwAkvWGfg=tEiczUWarO6y68KFD9EG9qZtGejng@mail.gmail.com>
 <Y2ILlpqFQVO9fH8B@sol.localdomain>
 <6f1d5006-95fb-cc63-4cb0-65de23cc4c27@kernel.org>
In-Reply-To: <6f1d5006-95fb-cc63-4cb0-65de23cc4c27@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2022/11/2 23:12, Chao Yu wrote:
> On 2022/11/2 14:17, Eric Biggers wrote:
>> [+f2fs list and maintainers]
> 
> Thanks for the forwarding.
> 
>> [changed subject from "INFO: task hung in fscrypt_ioctl_set_policy"]
>>
>> On Mon, Oct 31, 2022 at 10:18:02PM +0800, Wei Chen wrote:
>>> Dear Linux developers,
>>>
>>> Here is the link to the reproducers.
>>>
>>> C reproducer: https://drive.google.com/file/d/1mduYsYuoOKemH3qkvpDQwnAHAaaLUp0Y/view?usp=share_link
>>> Syz reproducer:
>>> https://drive.google.com/file/d/1mu-_w7dy_562vWRlQvTRbcBjG4_G7b2L/view?usp=share_link
>>>
>>> The bug persists in the latest commit, v5.15.76 (4f5365f77018). I hope
>>> it is helpful to you.
>>>
>>> [ 1782.137186][   T30] INFO: task a.out:6910 blocked for more than 143 seconds.
>>> [ 1782.139217][   T30]       Not tainted 5.15.76 #5
>>> [ 1782.140388][   T30] "echo 0 >
>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 1782.142524][   T30] task:a.out           state:D stack:14296 pid:
>>> 6910 ppid:  6532 flags:0x00004004
>>> [ 1782.144799][   T30] Call Trace:
>>> [ 1782.145623][   T30]  <TASK>
>>> [ 1782.146316][   T30]  __schedule+0x3e8/0x1850
>>> [ 1782.152029][   T30]  ? mark_held_locks+0x49/0x70
>>> [ 1782.153533][   T30]  ? mark_held_locks+0x10/0x70
>>> [ 1782.154759][   T30]  ? __down_write_common.part.14+0x31f/0x7b0
>>> [ 1782.156159][   T30]  schedule+0x4e/0xe0
>>> [ 1782.158314][   T30]  __down_write_common.part.14+0x324/0x7b0
>>> [ 1782.159704][   T30]  ? fscrypt_ioctl_set_policy+0xe0/0x200
>>> [ 1782.161050][   T30]  fscrypt_ioctl_set_policy+0xe0/0x200
>>> [ 1782.162330][   T30]  __f2fs_ioctl+0x9d6/0x45e0
>>> [ 1782.163417][   T30]  f2fs_ioctl+0x64/0x240
>>> [ 1782.164404][   T30]  ? __f2fs_ioctl+0x45e0/0x45e0
>>> [ 1782.165554][   T30]  __x64_sys_ioctl+0xb6/0x100
>>> [ 1782.166662][   T30]  do_syscall_64+0x34/0xb0
>>> [ 1782.169947][   T30]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
>>
>> Well, the quality of this bug report has a lot to be desired (not on upstream
>> kernel, reproducer is full of totally irrelevant stuff, not sent to the mailing
>> list of the filesystem whose disk image is being fuzzed, etc.).  But what is
>> going on is that f2fs_empty_dir() doesn't consider the case of a directory with
>> an extremely large i_size on a malicious disk image.
>>
>> Specifically, the reproducer mounts an f2fs image with a directory that has an
>> i_size of 14814520042850357248, then calls FS_IOC_SET_ENCRYPTION_POLICY on it.
>> That results in a call to f2fs_empty_dir() to check whether the directory is
>> empty.  f2fs_empty_dir() then iterates through all 3616826182336513 blocks the
>> directory allegedly contains to check whether any contain anything.  i_rwsem is
>> held during this, so anything else that tries to take it will hang.
>>
>> I'll look into this more if needed, but Jaegeuk and Chao, do you happen to have
>> any ideas for how f2fs_empty_dir() should be fixed?  Is there an easy way to
>> just iterate through the blocks that are actually allocated?
> 

Sorry, I mean:

 From 07f662ca6bd2a0991961ea42932ce90f19e74624 Mon Sep 17 00:00:00 2001
From: Chao Yu <chao@kernel.org>
Date: Wed, 2 Nov 2022 12:02:08 +0800
Subject: [RFC v2] f2fs: speed up f2fs_empty_dir()

Signed-off-by: Chao Yu <chao@kernel.org>
---
  fs/f2fs/dir.c | 48 ++++++++++++++++++++++++++++--------------------
  1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 21960a899b6a..569f7304e3e6 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -956,38 +956,46 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,

  bool f2fs_empty_dir(struct inode *dir)
  {
-	unsigned long bidx;
  	struct page *dentry_page;
  	unsigned int bit_pos;
  	struct f2fs_dentry_block *dentry_blk;
-	unsigned long nblock = dir_blocks(dir);
+	pgoff_t index;

  	if (f2fs_has_inline_dentry(dir))
  		return f2fs_empty_inline_dir(dir);

-	for (bidx = 0; bidx < nblock; bidx++) {
-		dentry_page = f2fs_get_lock_data_page(dir, bidx, false);
-		if (IS_ERR(dentry_page)) {
-			if (PTR_ERR(dentry_page) == -ENOENT)
-				continue;
-			else
-				return false;
-		}
+	dentry_page = f2fs_get_lock_data_page(dir, 0, false);
+	if (IS_ERR(dentry_page)) {
+		if (PTR_ERR(dentry_page) == -ENOENT)
+			return true;
+		return false;
+	}

-		dentry_blk = page_address(dentry_page);
-		if (bidx == 0)
-			bit_pos = 2;
-		else
-			bit_pos = 0;
-		bit_pos = find_next_bit_le(&dentry_blk->dentry_bitmap,
-						NR_DENTRY_IN_BLOCK,
-						bit_pos);
+	dentry_blk = page_address(dentry_page);
+	bit_pos = find_next_bit_le(&dentry_blk->dentry_bitmap,
+						NR_DENTRY_IN_BLOCK, 2);
+	f2fs_put_page(dentry_page, 1);
+	
+	if (bit_pos < NR_DENTRY_IN_BLOCK)
+		return false;

-		f2fs_put_page(dentry_page, 1);
+	for (index = 1; index < dir_blocks(dir);) {
+		struct dnode_of_data dn;
+		int err;

-		if (bit_pos < NR_DENTRY_IN_BLOCK)
+		set_new_dnode(&dn, dir, NULL, NULL, 0);
+		err = f2fs_get_dnode_of_data(&dn, index, LOOKUP_NODE);
+		if (err && err != -ENOENT) {
  			return false;
+		} else if (err == -ENOENT) {
+			index = f2fs_get_next_page_offset(&dn, index);
+			continue;
+		}
+		f2fs_put_dnode(&dn);
+
+		return false;
  	}
+
  	return true;
  }

-- 
2.36.1

