Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7E21404EB
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Jan 2020 09:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgAQIMr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 17 Jan 2020 03:12:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43712 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbgAQIMr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 17 Jan 2020 03:12:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=t/MEhEZGYZHmMiJmrgugavb+9sNbSeK5h6oldhHUYs8=; b=CBE9ZS2IjXbfrp+dvzcCM+LGx
        VZTVAlzWhocgiFF1/YMmGjxIEZ/q2YrWWmmFIXWh/MtSDaEomRJZPzpowabxJw89/lYJvFOTzFTTb
        15FsRdHD+UhNq+yMNIqE7bJ/9sUrZRPyiROdXSxQUV2MrRQCGaVv5X8CQmhAVgkzbVpSH4VD9xgEw
        iF5qutl89oTzwNv6K7NqOg/xSVNQDjb6ZpF+V6bQvMfGdzQ1ssvAE0sran+0msDNQl8ksQNVInVZy
        xApRZDzdrqjxxSAQGgoFXJPwSY6UAjMCuLJ/t31A4nvFhJqqaVXPV4DQIITCBoAPMsluWWM4958TK
        MyV2DTmUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isMkI-0004ao-RH; Fri, 17 Jan 2020 08:12:46 +0000
Date:   Fri, 17 Jan 2020 00:12:46 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Gaurav Kashyap <gaurkash@codeaurora.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH] fscrypt: reserve flags for hardware-wrapped keys feature
Message-ID: <20200117081246.GA16846@infradead.org>
References: <20200116192008.35766-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116192008.35766-1-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jan 16, 2020 at 11:20:08AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Reserve flags for the hardware-wrapped keys feature which is being
> worked on [1].  FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY will denote that the
> encryption policy needs a hardware-wrapped key to be unlocked.
> FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED will denote that the key being added is
> a hardware-wrapped key.
> 
> This reservation is tentative, and these codepoints may be reused if the
> feature is not upstreamed.

NAK.  While the feature itself sounds really useful we don't just
reserve format bits for code not upstream.
