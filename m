Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8900B12E3AF
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jan 2020 09:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbgABINk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Jan 2020 03:13:40 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:47834 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727714AbgABINk (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Jan 2020 03:13:40 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0EB227A12EFA22B63D6C;
        Thu,  2 Jan 2020 16:13:38 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.206) with Microsoft SMTP Server (TLS) id 14.3.439.0; Thu, 2 Jan 2020
 16:13:36 +0800
Subject: Re: [PATCH] f2fs: remove unneeded check for error allocating
 bio_post_read_ctx
To:     Eric Biggers <ebiggers@kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
CC:     <linux-fscrypt@vger.kernel.org>
References: <20191231181456.47957-1-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <d34f386f-437d-3564-745f-e8dd995bd2e6@huawei.com>
Date:   Thu, 2 Jan 2020 16:13:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20191231181456.47957-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2020/1/1 2:14, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since allocating an object from a mempool never fails when
> __GFP_DIRECT_RECLAIM (which is included in GFP_NOFS) is set, the check
> for failure to allocate a bio_post_read_ctx is unnecessary.  Remove it.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
