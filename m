Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D366C89E3C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 14:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfHLM0g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 08:26:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33682 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728240AbfHLM0g (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 08:26:36 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 77C083E30C9918E9E7E7;
        Mon, 12 Aug 2019 20:26:34 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.205) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 12 Aug
 2019 20:26:29 +0800
Subject: Re: [PATCH 6/6] f2fs: use EFSCORRUPTED in
 f2fs_get_verity_descriptor()
To:     Eric Biggers <ebiggers@kernel.org>, <linux-fscrypt@vger.kernel.org>
CC:     <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
References: <20190811213557.1970-1-ebiggers@kernel.org>
 <20190811213557.1970-7-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <41cd4406-9f81-94de-ce49-54d1b9442130@huawei.com>
Date:   Mon, 12 Aug 2019 20:26:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190811213557.1970-7-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2019/8/12 5:35, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> EFSCORRUPTED is now defined in f2fs.h, so use it instead of EUCLEAN.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Chao Yu <yuchao0@huawei.com>

Thanks,

