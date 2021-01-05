Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9812EA5C0
	for <lists+linux-fscrypt@lfdr.de>; Tue,  5 Jan 2021 08:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbhAEHMw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 5 Jan 2021 02:12:52 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10022 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbhAEHMw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 5 Jan 2021 02:12:52 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D93Z86c4Bzj3v8;
        Tue,  5 Jan 2021 15:11:12 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.207) with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 5 Jan 2021
 15:12:02 +0800
Subject: Re: [f2fs-dev] [PATCH v3] f2fs: clean up post-read processing
To:     Eric Biggers <ebiggers@kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
CC:     <linux-fscrypt@vger.kernel.org>
References: <20210105063302.59006-1-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <68f34ca7-85ee-75ce-f8b5-f56812cc332c@huawei.com>
Date:   Tue, 5 Jan 2021 15:12:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20210105063302.59006-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2021/1/5 14:33, Eric Biggers wrote:
> From: Eric Biggers<ebiggers@google.com>
> 
> Rework the post-read processing logic to be much easier to understand.
> 
> At least one bug is fixed by this: if an I/O error occurred when reading
> from disk, decryption and verity would be performed on the uninitialized
> data, causing misleading messages in the kernel log.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
