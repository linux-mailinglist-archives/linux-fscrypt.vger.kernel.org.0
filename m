Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F43D274377
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Sep 2020 15:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgIVNu7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Sep 2020 09:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgIVNu7 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Sep 2020 09:50:59 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9067720936;
        Tue, 22 Sep 2020 13:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600782658;
        bh=ah1oRV9AwF+HOR2QyLQpuVaKZLQO4RCWcJodnzc0oZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lFnv75YWIDQtPV1/37RjVPZCmc+w2raAzyDf/lBUX1xGdOF8/y+Of5HNgNyEuZYLq
         xs9upAb8I7B4MYDl7BdVbpmP9X/DKc9mF/70oyWM03GRglhaS8264ijKmOZchSpuYs
         fmOc1tLmvl8aKCckC1nqPNCydNFXGW3Um2IiQCWY=
Date:   Tue, 22 Sep 2020 06:50:57 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 00/13] fscrypt: improve file creation flow
Message-ID: <20200922135057.GA5599@sol.localdomain>
References: <20200917041136.178600-1-ebiggers@kernel.org>
 <20200921223509.GB844@sol.localdomain>
 <da7f608e01cd8725d8da668f1c4a847b29b9de68.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da7f608e01cd8725d8da668f1c4a847b29b9de68.camel@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 22, 2020 at 07:29:45AM -0400, Jeff Layton wrote:
> > 
> > All applied to fscrypt.git#master for 5.10.
> > 
> > I'd still really appreciate more reviews and acks, though.
> > 
> 
> You can add this to all of the fscrypt: patches. I've tested this under
> the ceph patchset and it seems to do the right thing:
> 
> Acked-by: Jeff Layton <jlayton@kernel.org>
> 

Thanks, added.

- Eric
