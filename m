Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574B1393A15
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 May 2021 02:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbhE1AOU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 May 2021 20:14:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234573AbhE1AOQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 May 2021 20:14:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E84D1613B6;
        Fri, 28 May 2021 00:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622160762;
        bh=71pzvdAMyAxadmBGtbgFS3tTAduPqfB1ZrDgW23iYXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hu9/hXcUSEUHjeLhkboF3pLiaOs02j8I1WsrnFmoFu0OBrh1fES17MkbHkOL2h7GZ
         NTFET2q1j63UrzcmaHFg0Eqdqqeda9bXl8qOe8uU4cFthbgB7+E96qLG4FyWGYYY0k
         uHHZoAZuk+Xf7Mm2bqPeLgXEklJkhLx3AHKn0ZtEKLluwKUQnvCWiKahJY9jwwjzEC
         caKS8bijXfFudhonjnRs5l2QzM/6Dex92lyJoYTI/8EllqjtImcbHvGmS4ERdcRkSB
         Tg35LkmGrtiQTm1WAKI/F8zaEA8k+zX/dHoRT6MQKtOHSyYKD2Xnek/2xBKLTl99M7
         c+WW7Nh/Qr86A==
Date:   Thu, 27 May 2021 17:12:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jerry Chung <jchung@proofpoint.com>
Cc:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: Is fscrypt encryption FIPS compliant?
Message-ID: <YLA1eIEOi3yHWk4X@gmail.com>
References: <BL1PR12MB5334C36420D5A8669D7856BFA0239@BL1PR12MB5334.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5334C36420D5A8669D7856BFA0239@BL1PR12MB5334.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, May 27, 2021 at 08:08:20PM +0000, Jerry Chung wrote:
> Hi Team,
> 
> I am considering to use `fscrypt` to encrypt directory files and just wondered if fscrypt encryption is complaint with FIPS. If so, would it be possible to get the CMVP number for that? If not, is there any plan to get the certification?
> 
> Thanks,
> Jerry Chung

No, there is no plan to certify fscrypt (kernel part or userspace part) as a
FIPS cryptographic module.

- Eric
