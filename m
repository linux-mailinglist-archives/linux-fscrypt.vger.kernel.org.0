Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9025565950F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Dec 2022 06:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiL3FpJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 30 Dec 2022 00:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiL3FpI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 30 Dec 2022 00:45:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2B4164AE
        for <linux-fscrypt@vger.kernel.org>; Thu, 29 Dec 2022 21:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672379060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5QANIqQaUJhASIgbMI+XkO113Zld6lw9QYz8izkwtzE=;
        b=IvKRvcyR/CvJ4WOmjLFDHesLGJ9n1KlxqfBpnts0Y+QqOs61iJPPc53smrwGGZ/pSpVbeR
        zr/BLKBW35TGVprEktPJIam7wlUzg2oJTESffwH3BUv9I8kBp513OxPDcx/oeW/2npSNOb
        fBp7IxBFO1xSN5BGxwtXpepMaeJ2RDk=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-439-Ih9maITXO6-yAEhm0tjyAw-1; Fri, 30 Dec 2022 00:44:19 -0500
X-MC-Unique: Ih9maITXO6-yAEhm0tjyAw-1
Received: by mail-pf1-f200.google.com with SMTP id t16-20020aa79390000000b0057fd4bf27fbso10245853pfe.4
        for <linux-fscrypt@vger.kernel.org>; Thu, 29 Dec 2022 21:44:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5QANIqQaUJhASIgbMI+XkO113Zld6lw9QYz8izkwtzE=;
        b=ACr2cbp4xDcs8NRZnmZTSHpUT/YiDTtCM5F99Cz3z3vdvTq87gLkaciDKy1xui3ZGH
         9F6dAthxGGS6HuIlH02BJdM8rUAqwRSsrTvne+MI6NX9ZGR29fOUOEOrKztt5LqHwgpP
         H/71CCV4ZISINfS2OAJuqFuKC2vU8Mf8U58iEYOjCJHVjvNULXHKmt8KrjnHLnDUvJCQ
         l3eEMhS8BJRCBflRB/ml2DJBBxj8oNiHGuJei0kbQ5Ceu2IQetwK0NgB0czTuR5vF/E6
         6R12IcgbulSxl4/xSkR/mtplTzET36J5q1rPmQ63GGkV7qw1VV5bQCZVSZU1aRyu99N4
         n/mQ==
X-Gm-Message-State: AFqh2kqsroFvmjjkIlOMd5SMsLFeR7rkfOWdxI9ufP/oBsJMaINJvgjr
        66EqItXikZ7SCaA/40seKbaaKes0D9e9JhkPZ7R2Vd9GofmUYPHH5xIm4/O2Ddbq0H4T7V0yDlS
        DMI5zuMqm93fJcWgohpyJxBkL61yo0z7uad4wnk4b1q1PtucbYtI/3fBYJPbFHaiNSOVFcDazaY
        M=
X-Received: by 2002:a05:6300:8184:b0:b0:3e0f:508d with SMTP id bt4-20020a056300818400b000b03e0f508dmr37649287pzc.55.1672379057849;
        Thu, 29 Dec 2022 21:44:17 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvvlWizGl4YUhQNCQyx8rZjX2VrRmSTpp2qe9uPP+8+Ash7c5zJHBBIm0VC/od4MTv5cT+C2g==
X-Received: by 2002:a05:6300:8184:b0:b0:3e0f:508d with SMTP id bt4-20020a056300818400b000b03e0f508dmr37649269pzc.55.1672379057488;
        Thu, 29 Dec 2022 21:44:17 -0800 (PST)
Received: from [10.72.13.122] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k10-20020a634b4a000000b00478b2d5d148sm11857847pgl.5.2022.12.29.21.44.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 21:44:17 -0800 (PST)
Subject: Re: [PATCH] ceph: make sure all the files successfully put before
 unmounting
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        khiremat@redhat.com, linux-fscrypt@vger.kernel.org
References: <20221201065800.18149-1-xiubli@redhat.com>
 <Y4j+Ccqzi6JxWchv@sol.localdomain> <Y4kYN8FPeq6NDe5i@gmail.com>
 <b30e579d-6919-d35b-aaa5-b71129a32810@redhat.com>
 <Y4l8vDmKIpypc8I3@sol.localdomain>
 <c0925b4f-ef5f-31fc-1bd0-05fa097b6b34@redhat.com>
 <Y64oe9c9U1+Y98yt@sol.localdomain>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8443166a-7182-7777-a489-14b5dab20bd5@redhat.com>
Date:   Fri, 30 Dec 2022 13:44:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y64oe9c9U1+Y98yt@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

Happy New Year!

Yeah, it's a ceph side bug and I have sent a patch to fix it [1].

When unmounting and just before closing the sessions the cephfs server 
still could send cap message to kceph and it will hold the inodes. So 
the unmount will skip them.

IMO it still makes sense to improve the vfs code because I hit a crash 
after this happening but just one time.

[1] 
https://patchwork.kernel.org/project/ceph-devel/patch/20221221093031.132792-1-xiubli@redhat.com/

Thanks

- Xiubo


On 30/12/2022 07:53, Eric Biggers wrote:
> Hi Xiubo,
>
> On Fri, Dec 02, 2022 at 03:04:58PM +0800, Xiubo Li wrote:
>> On 02/12/2022 12:19, Eric Biggers wrote:
>>> On Fri, Dec 02, 2022 at 09:49:49AM +0800, Xiubo Li wrote:
>>>> On 02/12/2022 05:10, Eric Biggers wrote:
>>>>> On Thu, Dec 01, 2022 at 11:18:33AM -0800, Eric Biggers wrote:
>>>>>> On Thu, Dec 01, 2022 at 02:58:00PM +0800, xiubli@redhat.com wrote:
>>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>>
>>>>>>> When close a file it will be deferred to call the fput(), which
>>>>>>> will hold the inode's i_count. And when unmounting the mountpoint
>>>>>>> the evict_inodes() may skip evicting some inodes.
>>>>>>>
>>>>>>> If encrypt is enabled the kernel generate a warning when removing
>>>>>>> the encrypt keys when the skipped inodes still hold the keyring:
>>>>>> This does not make sense.  Unmounting is only possible once all the files on the
>>>>>> filesystem have been closed.
>>>>>>
>>>>> Specifically, __fput() puts the reference to the dentry (and thus the inode)
>>>>> *before* it puts the reference to the mount.  And an unmount cannot be done
>>>>> while the mount still has references.  So there should not be any issue here.
>>>> Eric,
>>>>
>>>> When I unmounting I can see the following logs, which I added a debug log in
>>>> the evcit_inodes():
>>>>
>>>> diff --git a/fs/inode.c b/fs/inode.c
>>>> index b608528efd3a..f6e69b778d9c 100644
>>>> --- a/fs/inode.c
>>>> +++ b/fs/inode.c
>>>> @@ -716,8 +716,11 @@ void evict_inodes(struct super_block *sb)
>>>>    again:
>>>>           spin_lock(&sb->s_inode_list_lock);
>>>>           list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
>>>> -               if (atomic_read(&inode->i_count))
>>>> +               if (atomic_read(&inode->i_count)) {
>>>> +                       printk("evict_inodes inode %p, i_count = %d, was
>>>> skipped!\n",
>>>> +                              inode, atomic_read(&inode->i_count));
>>>>                           continue;
>>>> +               }
>>>>
>>>>                   spin_lock(&inode->i_lock);
>>>>                   if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
>>>>
>>>> The logs:
>>>>
>>>> <4>[   95.977395] evict_inodes inode 00000000f90aab7b, i_count = 1, was
>>>> skipped!
>>>>
>>>> Any reason could cause this ? Since the inode couldn't be evicted in time
>>>> and then when removing the master keys it will print this warning.
>>>>
>>> It is expected for evict_inodes() to see some inodes with nonzero refcount, but
>>> they should only be filesystem internal inodes.  For example, with ext4 this
>>> happens with the journal inode.
>>>
>>> However, filesystem internal inodes cannot be encrypted, so they are irrelevant
>>> here.
>>>
>>> I'd guess that CephFS has a bug where it is leaking a reference to a user inode
>>> somewhere.
>> I also added some debug logs to tracker all the inodes in ceph, and all the
>> requests has been finished.
>>
>> I will debug it more to see whether it's leaking a reference here.
>>
>> Thanks Eric.
>>
> Any progress on tracking this down?
>
> - Eric
>

