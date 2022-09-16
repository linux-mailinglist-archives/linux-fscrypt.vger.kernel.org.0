Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37BD5BB48C
	for <lists+linux-fscrypt@lfdr.de>; Sat, 17 Sep 2022 00:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiIPWz4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 16 Sep 2022 18:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiIPWzy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 16 Sep 2022 18:55:54 -0400
X-Greylist: delayed 2219 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Sep 2022 15:55:52 PDT
Received: from mx1.supremebox.com (mx2.supremebox.com [198.23.53.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B00EABF10;
        Fri, 16 Sep 2022 15:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=jilayne.com
        ; s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EJzOhgSSv2MWdF1Cpycu1xYUB5X/V+5T1f/8hC9RPmc=; b=J2iMMXA6DFtSl8eNUhs170UAPv
        RHwcP7RZmV04ha33f7fgnW+nS4FJ446fqNJRQ/vSj9u/jCTdFsTJidtZhLIxkE+p5lnnwLVDEOIg/
        WzvtrPWOLMyoh+/ao3RgnoBFlDHY7RUVSQD5yg0V5y1sYHQq5hEumljIwKOniHJTdPbY=;
Received: from 71-211-172-5.hlrn.qwest.net ([71.211.172.5] helo=[192.168.0.91])
        by mx1.supremebox.com with esmtpa (Exim 4.92)
        (envelope-from <opensource@jilayne.com>)
        id 1oZJfd-0002GR-Fu; Fri, 16 Sep 2022 22:18:49 +0000
Message-ID: <b4d3d155-e614-2075-8918-3082c42e099f@jilayne.com>
Date:   Fri, 16 Sep 2022 16:18:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
Content-Language: en-US
To:     dsterba@suse.cz, Christoph Hellwig <hch@infradead.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>, linux-spdx@vger.kernel.org
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <685c8abce7bdb110bc306752314b4fb0e7867290.1662420176.git.sweettea-kernel@dorminy.me>
 <20220909101521.GS32411@twin.jikos.cz> <Yxs43SlMqqJ4Fa2h@infradead.org>
 <20220909133400.GY32411@twin.jikos.cz>
From:   J Lovejoy <opensource@jilayne.com>
In-Reply-To: <20220909133400.GY32411@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Sender-Ident-agJab5osgicCis: opensource@jilayne.com
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 9/9/22 7:34 AM, David Sterba wrote:
> On Fri, Sep 09, 2022 at 06:00:13AM -0700, Christoph Hellwig wrote:
>> On Fri, Sep 09, 2022 at 12:15:21PM +0200, David Sterba wrote:
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/*
>>>> + * Copyright (C) 2020 Facebook
>>>> + */
>>> Please use only SPDX in new files
>>>
>>> https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Copyright_notices_in_files.2C_SPDX
>> The wiki is incorrect.  The SPDX tag deals with the licensing tags
>> only.  It is not a replacement for the copyright notice in any way, and
>> having been involved with Copyright enforcement I can tell you that
>> at least in some jurisdictions Copytight notices absolutely do matter.
> I believe you and can update the wiki text so it's more explicit about
> the license an copyright.

Can you update the wiki text to remove "SPDX" from the heading and 
remove the sentence stating, "An initiative started in 2017 [1] aims to 
unify licensing information in all files using SPDX tags, this is driven 
by the Linux Foundation."

Thanks,
Jilayne

