Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58899171EC
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 May 2019 08:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfEHGtW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>); Wed, 8 May 2019 02:49:22 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:34712 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfEHGtW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 May 2019 02:49:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id DBB1C6083252;
        Wed,  8 May 2019 08:49:18 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Q22Vkv5wiLM7; Wed,  8 May 2019 08:49:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 72C4B6083269;
        Wed,  8 May 2019 08:49:18 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Yig6-Nlv4VD1; Wed,  8 May 2019 08:49:18 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 4BBA46083252;
        Wed,  8 May 2019 08:49:18 +0200 (CEST)
Date:   Wed, 8 May 2019 08:49:18 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-fscrypt@vger.kernel.org, tytso <tytso@mit.edu>,
        kernel <kernel@pengutronix.de>
Message-ID: <1170873772.48849.1557298158182.JavaMail.zimbra@nod.at>
In-Reply-To: <20190508031954.GA26575@sol.localdomain>
References: <20190326075232.11717-1-s.hauer@pengutronix.de> <20190326075232.11717-2-s.hauer@pengutronix.de> <20190508031954.GA26575@sol.localdomain>
Subject: Re: [PATCH 1/2] ubifs: Remove #ifdef around CONFIG_FS_ENCRYPTION
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.8_GA_3025 (ZimbraWebClient - FF60 (Linux)/8.8.8_GA_1703)
Thread-Topic: ubifs: Remove #ifdef around CONFIG_FS_ENCRYPTION
Thread-Index: nv8odDrziMGsORrNKuAatbhNUuTenA==
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Eric,

----- Ursprüngliche Mail -----
> Von: "Eric Biggers" <ebiggers@kernel.org>
> An: "Sascha Hauer" <s.hauer@pengutronix.de>, "richard" <richard@nod.at>
> CC: "linux-mtd" <linux-mtd@lists.infradead.org>, linux-fscrypt@vger.kernel.org, "tytso" <tytso@mit.edu>, "kernel"
> <kernel@pengutronix.de>
> Gesendet: Mittwoch, 8. Mai 2019 05:19:55
> Betreff: Re: [PATCH 1/2] ubifs: Remove #ifdef around CONFIG_FS_ENCRYPTION

> On Tue, Mar 26, 2019 at 08:52:31AM +0100, Sascha Hauer wrote:
>> ifdefs reduce readablity and compile coverage. This removes the ifdefs
>> around CONFIG_FS_ENCRYPTION by using IS_ENABLED and relying on static
>> inline wrappers. A new static inline wrapper for setting sb->s_cop is
>> introduced to allow filesystems to unconditionally compile in their
>> s_cop operations.
>> 
>> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
>> ---
>>  fs/ubifs/ioctl.c        | 11 +----------
>>  fs/ubifs/sb.c           |  7 ++++---
>>  fs/ubifs/super.c        |  4 +---
>>  include/linux/fscrypt.h | 11 +++++++++++
>>  4 files changed, 17 insertions(+), 16 deletions(-)
>> 
>> diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
>> index 82e4e6a30b04..6b05b3ec500e 100644
>> --- a/fs/ubifs/ioctl.c
>> +++ b/fs/ubifs/ioctl.c
>> @@ -193,7 +193,6 @@ long ubifs_ioctl(struct file *file, unsigned int cmd,
>> unsigned long arg)
>>  		return err;
>>  	}
>>  	case FS_IOC_SET_ENCRYPTION_POLICY: {
>> -#ifdef CONFIG_FS_ENCRYPTION
>>  		struct ubifs_info *c = inode->i_sb->s_fs_info;
>>  
>>  		err = ubifs_enable_encryption(c);
>> @@ -201,17 +200,9 @@ long ubifs_ioctl(struct file *file, unsigned int cmd,
>> unsigned long arg)
>>  			return err;
>>  
>>  		return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
>> -#else
>> -		return -EOPNOTSUPP;
>> -#endif
>>  	}
>> -	case FS_IOC_GET_ENCRYPTION_POLICY: {
>> -#ifdef CONFIG_FS_ENCRYPTION
>> +	case FS_IOC_GET_ENCRYPTION_POLICY:
>>  		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
>> -#else
>> -		return -EOPNOTSUPP;
>> -#endif
>> -	}
>>  
>>  	default:
>>  		return -ENOTTY;
>> diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
>> index 67fac1e8adfb..2afc8b1d4c3b 100644
>> --- a/fs/ubifs/sb.c
>> +++ b/fs/ubifs/sb.c
>> @@ -748,14 +748,12 @@ int ubifs_read_superblock(struct ubifs_info *c)
>>  		goto out;
>>  	}
>>  
>> -#ifndef CONFIG_FS_ENCRYPTION
>> -	if (c->encrypted) {
>> +	if (!IS_ENABLED(CONFIG_UBIFS_FS_ENCRYPTION) && c->encrypted) {
>>  		ubifs_err(c, "file system contains encrypted files but UBIFS"
>>  			     " was built without crypto support.");
>>  		err = -EINVAL;
>>  		goto out;
>>  	}
> 
> A bit late, but I noticed this in ubifs/linux-next.  This needs to use
> CONFIG_FS_ENCRYPTION here, not CONFIG_UBIFS_FS_ENCRYPTION, as the latter no
> longer exists.

Thanks for spotting. I'll fit it myself in -next.

Thanks,
//richard
