Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A5518B187
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 Mar 2020 11:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCSKdn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 Mar 2020 06:33:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37282 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgCSKdn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 Mar 2020 06:33:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cHEIfPKeH9omjNt+0k991N/wm6h5xTiMPSj7a3ocvkk=; b=fqbeo36MCxVADWcrpk/D9GeNit
        YSF85PIZ5pZRnh/gMtR2c79Jsb8L7YhvvN64lZ60kOxZfWWSJ6Ae7O7AhkL3Ayjae3KYft2zXedIR
        fNP+IugcEnmbNPTGciEn4qpUnj9OXjNyaCy7HO5i7Tky2zl+Ayw3wB4suhJF04W2+8RWQ7KuGpZAg
        UJRxkefSD6ewnGd+iAQwAMtrwc9GVUoW5gZ/n8IDzmU5MBqMX2hMy7c+8sJXOpCVTfBuF7DEYMNPF
        DEC44x4DgN1K7/3nnWxzQZlc3UczWGFRgrmw9tLdY3dxsXFsfrVkzF/N7t0J1mofyKqstCyOChcH9
        kcg8bDNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEsUg-0001WX-9j; Thu, 19 Mar 2020 10:33:42 +0000
Date:   Thu, 19 Mar 2020 03:33:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [RFC PATCH v3 4/4] scsi: ufs-qcom: add Inline Crypto Engine
 support
Message-ID: <20200319103342.GB30601@infradead.org>
References: <20200312171259.151442-1-ebiggers@kernel.org>
 <20200312171259.151442-5-ebiggers@kernel.org>
 <BY5PR02MB65778B0D07AA92F6AB5E39E8FFFD0@BY5PR02MB6577.namprd02.prod.outlook.com>
 <20200312190541.GB6470@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312190541.GB6470@sol.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 12, 2020 at 12:05:41PM -0700, Eric Biggers wrote:
> Of course, if someone actually posts patches to support hardware that diverges
> from the UFS standard in new and "exciting" ways (whether it's another vendor's
> hardware or future Qualcomm hardware) then they'll need to post any variant
> operation(s) they need.  They need to be targetted to only the specific quirk(s)
> needed, so that drivers don't have to unnecessarily re-implement stuff.

I think the only sane answer is that we only support hardware upstream
that conforms to the standard and we skip all that bullshit.  The whole
point of the standard is that things just work, and we should not give
vendors a wild card to come up with bullshit like the interfaces handled
in this patchset.
