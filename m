Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65FBDF1A8D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Nov 2019 16:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfKFP6U (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 6 Nov 2019 10:58:20 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35429 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727958AbfKFP6U (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 6 Nov 2019 10:58:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9090D2249A
        for <linux-fscrypt@vger.kernel.org>; Wed,  6 Nov 2019 10:58:19 -0500 (EST)
Received: from imap37 ([10.202.2.87])
  by compute3.internal (MEProxy); Wed, 06 Nov 2019 10:58:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=wx/XOOfndZtw8yATlX1mXrqUsnW1y
        BkLA/rkT7iNF/Q=; b=lzQsKBwOM5vHxvgDkTfD6nxVTV45QGBdbzZJjoIc81ZGZ
        qQdK26wjSOosw9KbqW83TQk+82VmPWxj6jLmPC0PeHNdJKnj99kxDQFfaZZUzAtD
        7ZQPYfmaWdPwVgvla4d67Da+QPSXub19YLeopE/M9/YXwPhdq63S8g90VdDlcFm8
        yhrkOxgU/RP+OrVjTh7f+l5mIwQEhj0IvwspFkjPTPH95u1kiIYMxG1bdHQhyP+P
        DPG1xsrgmG5kerbQrKg3bIzrYmWpTm6O5lbSZznsat2ehkQworRwfkU5ZKInuCME
        lB8sWhNkdRxPHCW4rdnzXHwKgjPjbiGNlno6MK2BQ==
X-ME-Sender: <xms:m-3CXe1Dno10LKXWestBfQ6knK80mUOT7wq317cDkkaih-Z1nqtf-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddujedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfffhffvufgtsehttdertd
    erredtnecuhfhrohhmpedfveholhhinhcuhggrlhhtvghrshdfuceofigrlhhtvghrshes
    vhgvrhgsuhhmrdhorhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgihhthh
    husgdrtghomhenucfrrghrrghmpehmrghilhhfrhhomhepfigrlhhtvghrshesvhgvrhgs
    uhhmrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:m-3CXXrji7cb84RfsoRmS9fnwhKS7JY4a5Jbef6IpJsc6b48sUmjow>
    <xmx:m-3CXYnUSmoq0e1xmkYZNsOayflA41NOK50M8rc0GUJJMAzcb1acFQ>
    <xmx:m-3CXZTmCuvPgduo48Zkk8fZI6TetTuW5jLduGcH2Slz6Og1E9iz8w>
    <xmx:m-3CXYj90edscMLLJ_XgWYeVA4ELVaiRYlDQp9ZP54urbpVDCBCvig>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3C663684005F; Wed,  6 Nov 2019 10:58:19 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-509-ge3ec61c-fmstable-20191030v1
Mime-Version: 1.0
Message-Id: <3c1e9aca-2390-4350-a19d-baff6a065c6a@www.fastmail.com>
Date:   Wed, 06 Nov 2019 10:57:08 -0500
From:   "Colin Walters" <walters@verbum.org>
To:     linux-fscrypt@vger.kernel.org
Subject: version/tags for fsverity-utils
Content-Type: text/plain
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi, I'm looking at fsverity for Fedora CoreOS (a bit more background in https://github.com/ostreedev/ostree/pull/1959 )
I have a bunch of questions there (feel free to jump in), but just to start here: 

I'd like to get fsverity-utils as a Fedora package, but there don't seem to be any git tags on the repo https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/  - I could make up a datestamped version number, but I think it'd be better if there were upstream tags - it is useful to have releases with human-consumable version numbers for the usual reasons. And RPM/dpkg/etc really care about the version numbers of packages.

Other distributions/some packagers think "release" means tarballs, so someone may want to consider that too, personally 
I use https://github.com/cgwalters/git-evtag for making git tags since I think it helps replace tarballs.
