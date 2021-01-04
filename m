Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F4F2E8F9F
	for <lists+linux-fscrypt@lfdr.de>; Mon,  4 Jan 2021 04:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbhADDgp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 3 Jan 2021 22:36:45 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10379 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbhADDgo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 3 Jan 2021 22:36:44 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D8LqJ70FYz7PxB;
        Mon,  4 Jan 2021 11:35:08 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.203) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 4 Jan 2021
 11:35:59 +0800
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: clean up post-read processing
To:     Eric Biggers <ebiggers@kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
CC:     <linux-fscrypt@vger.kernel.org>
References: <20201228232612.45538-1-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <a43158eb-114e-7f7f-871a-7bd9c70639d6@huawei.com>
Date:   Mon, 4 Jan 2021 11:35:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20201228232612.45538-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2020/12/29 7:26, Eric Biggers wrote:
> +	if (ctx && (ctx->enabled_steps & (STEP_DECRYPT | STEP_DECOMPRESS))) {
> +		INIT_WORK(&ctx->work, f2fs_post_read_work);
> +		queue_work(ctx->sbi->post_read_wq, &ctx->work);

Could you keep STEP_DECOMPRESS_NOWQ related logic? so that bio only includes
non-compressed pages could be handled in irq context rather than in wq context
which should be unneeded.

Thanks,

> +	} else {
> +		f2fs_verify_and_finish_bio(bio);
> +	}
