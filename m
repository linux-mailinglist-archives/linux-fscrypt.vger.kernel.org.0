Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF993BE710
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Jul 2021 13:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhGGL2g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Jul 2021 07:28:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231321AbhGGL2f (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Jul 2021 07:28:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625657155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4KtAI8w2GPScf+wF2HpEDXs0DTyY2Uj+uMXcwJsLn10=;
        b=X7y/gWOQERMhIhRHYBjAzu2H2gNN0hWPoULVtgdUHciVebdxEVv2BDItsHanoz4P0gIMIo
        oMPKoDdH6DQJHWoiPGCcDHiNUgid3TXtl38YQXYITAm0c0B64GzS9n0M/gErIT84mFTeS8
        0/Fl5z6usXIYVlO+4OTp6lFaflKFf6c=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-NcbX2vrmP3mRStnfm51Izg-1; Wed, 07 Jul 2021 07:25:54 -0400
X-MC-Unique: NcbX2vrmP3mRStnfm51Izg-1
Received: by mail-oi1-f199.google.com with SMTP id u63-20020acac4420000b029024085cadfcbso1674028oif.23
        for <linux-fscrypt@vger.kernel.org>; Wed, 07 Jul 2021 04:25:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4KtAI8w2GPScf+wF2HpEDXs0DTyY2Uj+uMXcwJsLn10=;
        b=g/RJR0Eq8qjgxkbVAYG6U5T8gMOb7rDevsXC7hONya55EEdeY2NMHslCckLgAPhD58
         6/Ow4q5aWWdiyRIj+uf15XJTmDhhmd5F7/Foe9Gcm8LpYkvdlKzzYyFdukTIu286ejNL
         piCK71epYN198vy/lRtCE3Tfvv5Gn/opv9BGuW/9uQYFFFL3CGJTS/uiGGW2OL33RBQY
         IpPHYp5h+7Z02IGCxRk8Nslfn7h/hLgkMQNqqgtgvYBNuJWUI8Ry7EgJox5yLniMbbOO
         FJLtoMzgQ4bDbbx3dROAQDaI/Lm09xV243vZj09tKmOBTSS7+Ag9ucoiK2yx77EhHmi+
         vUlQ==
X-Gm-Message-State: AOAM532aHCwSesO8EFJ/JLqItE/0XEtb5CaJw0rO6miZRZg/lS+943Sd
        4SrZO8SPJvluojw0k7cAnpvXwG1H8MKyP2wGcldkf/quSf3sPgsv9XFmgEssepuoXBd04yEZG+E
        WdpMzzBjw2C0X4PPFpYmeQDOkkw==
X-Received: by 2002:a17:90a:cd01:: with SMTP id d1mr5598217pju.106.1625656800824;
        Wed, 07 Jul 2021 04:20:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+Rxc56o+TvLdCn9mDQnImnYH2E/U+pz583aSQIIdatNKvyI/zqciTHl7ZLnH2gh05OLPndA==
X-Received: by 2002:a17:90a:cd01:: with SMTP id d1mr5598189pju.106.1625656800517;
        Wed, 07 Jul 2021 04:20:00 -0700 (PDT)
Received: from [10.72.12.117] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ay3sm17447940pjb.38.2021.07.07.04.19.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 04:20:00 -0700 (PDT)
Subject: Re: [RFC PATCH v7 06/24] ceph: parse new fscrypt_auth and
 fscrypt_file fields in inode traces
To:     Luis Henriques <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, dhowells@redhat.com
References: <20210625135834.12934-1-jlayton@kernel.org>
 <20210625135834.12934-7-jlayton@kernel.org> <YOWGPv099N7EsMVA@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <14d96eb9-c9b5-d854-d87a-65c1ab3be57e@redhat.com>
Date:   Wed, 7 Jul 2021 19:19:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YOWGPv099N7EsMVA@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 7/7/21 6:47 PM, Luis Henriques wrote:
> On Fri, Jun 25, 2021 at 09:58:16AM -0400, Jeff Layton wrote:
>> ...and store them in the ceph_inode_info.
>>
>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>   fs/ceph/file.c       |  2 ++
>>   fs/ceph/inode.c      | 18 ++++++++++++++++++
>>   fs/ceph/mds_client.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>>   fs/ceph/mds_client.h |  4 ++++
>>   fs/ceph/super.h      |  6 ++++++
>>   5 files changed, 74 insertions(+)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 2cda398ba64d..ea0e85075b7b 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -592,6 +592,8 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
>>   	iinfo.xattr_data = xattr_buf;
>>   	memset(iinfo.xattr_data, 0, iinfo.xattr_len);
>>   
>> +	/* FIXME: set fscrypt_auth and fscrypt_file */
>> +
>>   	in.ino = cpu_to_le64(vino.ino);
>>   	in.snapid = cpu_to_le64(CEPH_NOSNAP);
>>   	in.version = cpu_to_le64(1);	// ???
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index f62785e4dbcb..b620281ea65b 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -611,6 +611,13 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>>   
>>   	ci->i_meta_err = 0;
>>   
>> +#ifdef CONFIG_FS_ENCRYPTION
>> +	ci->fscrypt_auth = NULL;
>> +	ci->fscrypt_auth_len = 0;
>> +	ci->fscrypt_file = NULL;
>> +	ci->fscrypt_file_len = 0;
>> +#endif
>> +
>>   	return &ci->vfs_inode;
>>   }
>>   
>> @@ -619,6 +626,9 @@ void ceph_free_inode(struct inode *inode)
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   
>>   	kfree(ci->i_symlink);
>> +#ifdef CONFIG_FS_ENCRYPTION
>> +	kfree(ci->fscrypt_auth);
>> +#endif
>>   	kmem_cache_free(ceph_inode_cachep, ci);
>>   }
>>   
>> @@ -1021,6 +1031,14 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>>   		xattr_blob = NULL;
>>   	}
>>   
>> +	if (iinfo->fscrypt_auth_len && !ci->fscrypt_auth) {
>> +		ci->fscrypt_auth_len = iinfo->fscrypt_auth_len;
>> +		ci->fscrypt_auth = iinfo->fscrypt_auth;
>> +		iinfo->fscrypt_auth = NULL;
>> +		iinfo->fscrypt_auth_len = 0;
>> +		inode_set_flags(inode, S_ENCRYPTED, S_ENCRYPTED);
>> +	}
> I think we also need to free iinfo->fscrypt_auth here if ci->fscrypt_auth
> is already set.  Something like:
>
> 	if (iinfo->fscrypt_auth_len) {
> 		if (!ci->fscrypt_auth) {
> 			...
> 		} else {
> 			kfree(iinfo->fscrypt_auth);
> 			iinfo->fscrypt_auth = NULL;
> 		}
> 	}
>
IMO, this should be okay because it will be freed in 
destroy_reply_info() when putting the request.


>> +
>>   	/* finally update i_version */
>>   	if (le64_to_cpu(info->version) > ci->i_version)
>>   		ci->i_version = le64_to_cpu(info->version);
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 3b3a14024ca0..9c994effc51d 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -183,8 +183,48 @@ static int parse_reply_info_in(void **p, void *end,
>>   			info->rsnaps = 0;
>>   		}
>>   
>> +		if (struct_v >= 5) {
>> +			u32 alen;
>> +
>> +			ceph_decode_32_safe(p, end, alen, bad);
>> +
>> +			while (alen--) {
>> +				u32 len;
>> +
>> +				/* key */
>> +				ceph_decode_32_safe(p, end, len, bad);
>> +				ceph_decode_skip_n(p, end, len, bad);
>> +				/* value */
>> +				ceph_decode_32_safe(p, end, len, bad);
>> +				ceph_decode_skip_n(p, end, len, bad);
>> +			}
>> +		}
>> +
>> +		/* fscrypt flag -- ignore */
>> +		if (struct_v >= 6)
>> +			ceph_decode_skip_8(p, end, bad);
>> +
>> +		if (struct_v >= 7) {
>> +			ceph_decode_32_safe(p, end, info->fscrypt_auth_len, bad);
>> +			if (info->fscrypt_auth_len) {
>> +				info->fscrypt_auth = kmalloc(info->fscrypt_auth_len, GFP_KERNEL);
>> +				if (!info->fscrypt_auth)
>> +					return -ENOMEM;
>> +				ceph_decode_copy_safe(p, end, info->fscrypt_auth,
>> +						      info->fscrypt_auth_len, bad);
>> +			}
>> +			ceph_decode_32_safe(p, end, info->fscrypt_file_len, bad);
>> +			if (info->fscrypt_file_len) {
>> +				info->fscrypt_file = kmalloc(info->fscrypt_file_len, GFP_KERNEL);
>> +				if (!info->fscrypt_file)
>> +					return -ENOMEM;
> As Xiubo already pointed out, there's a kfree(info->fscrypt_auth) missing
> in this error path.
>
> Cheers,
> --
> Luís
>
>> +				ceph_decode_copy_safe(p, end, info->fscrypt_file,
>> +						      info->fscrypt_file_len, bad);
>> +			}
>> +		}
>>   		*p = end;
>>   	} else {
>> +		/* legacy (unversioned) struct */
>>   		if (features & CEPH_FEATURE_MDS_INLINE_DATA) {
>>   			ceph_decode_64_safe(p, end, info->inline_version, bad);
>>   			ceph_decode_32_safe(p, end, info->inline_len, bad);
>> @@ -625,6 +665,10 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
>>   
>>   static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
>>   {
>> +	kfree(info->diri.fscrypt_auth);
>> +	kfree(info->diri.fscrypt_file);
>> +	kfree(info->targeti.fscrypt_auth);
>> +	kfree(info->targeti.fscrypt_file);
>>   	if (!info->dir_entries)
>>   		return;
>>   	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_size));
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index 64ea9d853b8d..0c3cc61fd038 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -88,6 +88,10 @@ struct ceph_mds_reply_info_in {
>>   	s32 dir_pin;
>>   	struct ceph_timespec btime;
>>   	struct ceph_timespec snap_btime;
>> +	u8 *fscrypt_auth;
>> +	u8 *fscrypt_file;
>> +	u32 fscrypt_auth_len;
>> +	u32 fscrypt_file_len;
>>   	u64 rsnaps;
>>   	u64 change_attr;
>>   };
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 0cd94b296f5f..e032737fe472 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -429,6 +429,12 @@ struct ceph_inode_info {
>>   
>>   #ifdef CONFIG_CEPH_FSCACHE
>>   	struct fscache_cookie *fscache;
>> +#endif
>> +#ifdef CONFIG_FS_ENCRYPTION
>> +	u32 fscrypt_auth_len;
>> +	u32 fscrypt_file_len;
>> +	u8 *fscrypt_auth;
>> +	u8 *fscrypt_file;
>>   #endif
>>   	errseq_t i_meta_err;
>>   
>> -- 
>> 2.31.1
>>

