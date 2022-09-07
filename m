Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58445B0E5E
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 22:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiIGUmr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Sep 2022 16:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIGUmq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Sep 2022 16:42:46 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CF1C0B66;
        Wed,  7 Sep 2022 13:42:44 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 924FF80F7C;
        Wed,  7 Sep 2022 16:42:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662583364; bh=9M14dS3Odflv4CHUsjQx8+CgonRJlWnYJ5HdiZwBDoU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=b+6sOex32ty8ifQJmSPdZE2VKrogIUATIvIC8235EdweZXu53pKksclkNdvJ8O4F8
         35f4IR0zmYDafYYHGd3N4k0CL/h2KS93csCTcxjwL1loF8JUNXuuEff5/CGI8LpoWh
         tXEqPj7lI3Ne/NbTFWZHqOUnQ2Xw4rYOnNszBjE0Djx9Tzt4SLVBStST9QNazVkibk
         6r/WCO6H9vw3No4f5DO8VnyOIw7a7o/7qA6dIfJUH5QKwGLS7qz3O/raCQUCZvZ8gW
         JKm1aG0AM86FEEB2zu7y7sPl4btjTmaW9ZNUxP0uwLvqLngIYrABa6r53NuOL0bVXc
         zbY7t6fTKWo0Q==
Message-ID: <24ea47b2-ec19-afdd-3faa-c3d86c6d498e@dorminy.me>
Date:   Wed, 7 Sep 2022 16:42:40 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v2 12/20] btrfs: start using fscrypt hooks.
Content-Language: en-US
To:     dsterba@suse.cz
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <4b27b127a4048a58af965634436b562ec1217c82.1662420176.git.sweettea-kernel@dorminy.me>
 <20220907201717.GK32411@twin.jikos.cz>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <20220907201717.GK32411@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 7216ac1f860c..929a0308676c 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -3695,6 +3695,9 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
>>   	int ret;
>>   
>>   	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
>> +	ret = fscrypt_file_open(inode, filp);
>> +	if (ret)
>> +		return ret;
>>   
>>   	ret = fsverity_file_open(inode, filp);
> 
> Can fsverity and fscrypt can be used at the same time?

Yes, and there's a fstest, generic/576, checking the hooks are in the 
right order.
