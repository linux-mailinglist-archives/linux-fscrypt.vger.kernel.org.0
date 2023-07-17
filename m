Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E2575591D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 03:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjGQBm1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 21:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjGQBm1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 21:42:27 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3C6E51;
        Sun, 16 Jul 2023 18:42:25 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7908D804CB;
        Sun, 16 Jul 2023 21:42:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689558144; bh=vJq5ZhwUBeOSNlMSsLevD9EVTog/fiaowZSFUc7n2yM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=vfuX81JhWQbet++hY84ZyHqNeCEFGrCjB7x7UbCn9v2/zXmdL4kSEjRyOUgrtsliu
         i/wfX9gz2ghaZVNh/gP/Kyc8jpnzqQA8eSPFIXb3sznGJFlQEiUNYMaRZH/Ybxwi85
         HHnbfPt9d5w2QnPV6NwVWebKjirTaWm4lo+e75HgdUu7MhwhGZDXFahTd+hjSCu1cj
         HqJb59weyHL1tNvs6AYMuLGtqFpcyikqFr9TYNgrEYgDsioV5gNiVljUuHHYR1/zXP
         U7CZ5xYbzMRAKp2eZsdlCBOOpM5XbBjO7Skydurfvfxesa74xrRskyaSh73dfJhqs2
         ZRBfvlonZqEIw==
Message-ID: <b6deef30-0dc5-929c-3dd6-f3016cd58c48@dorminy.me>
Date:   Sun, 16 Jul 2023 21:42:22 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v1 01/17] btrfs: disable various operations on encrypted
 inodes
Content-Language: en-US
To:     Boris Burkov <boris@bur.io>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
 <e7785ffe237e581a7ba7e45d2724fca4d8fa1470.1687988380.git.sweettea-kernel@dorminy.me>
 <20230707233605.GB2579580@zen>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <20230707233605.GB2579580@zen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 7/7/23 19:36, Boris Burkov wrote:
> On Wed, Jun 28, 2023 at 08:35:24PM -0400, Sweet Tea Dorminy wrote:
>> From: Omar Sandoval <osandov@osandov.com>
>>
>> Initially, only normal data extents, using the normal (non-direct) IO
>> path, will be encrypted. This change forbids various other bits:
>> - allows reflinking only if both inodes have the same encryption status
>> - disables direct IO on encrypted inodes
>> - disable inline data on encrypted inodes
>>
>> Signed-off-by: Omar Sandoval <osandov@osandov.com>
>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>> ---
>>   fs/btrfs/file.c    | 4 ++--
>>   fs/btrfs/inode.c   | 3 ++-
>>   fs/btrfs/reflink.c | 7 +++++++
>>   3 files changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 392bc7d512a0..354962a7dd72 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -1502,7 +1502,7 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>>   		goto relock;
>>   	}
>>   
>> -	if (check_direct_IO(fs_info, from, pos)) {
>> +	if (IS_ENCRYPTED(inode) || check_direct_IO(fs_info, from, pos)) {
>>   		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
>>   		goto buffered;
>>   	}
>> @@ -3741,7 +3741,7 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
>>   	ssize_t read = 0;
>>   	ssize_t ret;
>>   
>> -	if (fsverity_active(inode))
>> +	if (IS_ENCRYPTED(inode) || fsverity_active(inode))
> 
> What's different about fscrypt vs fsverity that makes the inode flag a
> good check for encryption while verity relies on the presence of the
> extra context metadata?
> 
> Is the enable model not subject to the same race where S_VERITY gets set
> ahead of actually storing the verity info/item?
> 
> I think it's fine for these "skip" cases, but I imagine if we have cases
> of "I want a fully ready encrypted file" the verity-style check could be
> better?
> 
Clear solution: enable direct encrypted IO :). I've removed this check 
altogether, thanks for the note.
