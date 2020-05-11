Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C201CCFDA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 May 2020 04:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgEKCrL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 10 May 2020 22:47:11 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34348 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725830AbgEKCrL (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 10 May 2020 22:47:11 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 273AE9932FD76AB32617;
        Mon, 11 May 2020 10:47:10 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.201) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 11 May
 2020 10:47:07 +0800
Subject: Re: [PATCH 2/4] f2fs: split f2fs_d_compare() from f2fs_match_name()
To:     Eric Biggers <ebiggers@kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
CC:     <linux-fscrypt@vger.kernel.org>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
References: <20200507075905.953777-1-ebiggers@kernel.org>
 <20200507075905.953777-3-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <a6271be8-6296-0fda-b832-ffda6b063338@huawei.com>
Date:   Mon, 11 May 2020 10:47:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200507075905.953777-3-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2020/5/7 15:59, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Sharing f2fs_ci_compare() between comparing cached dentries
> (f2fs_d_compare()) and comparing on-disk dentries (f2fs_match_name())
> doesn't work as well as intended, as these actions fundamentally differ
> in several ways (e.g. whether the task may sleep, whether the directory
> is stable, whether the casefolded name was precomputed, whether the
> dentry will need to be decrypted once we allow casefold+encrypt, etc.)
> 
> Just make f2fs_d_compare() implement what it needs directly, and rework
> f2fs_ci_compare() to be specialized for f2fs_match_name().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
