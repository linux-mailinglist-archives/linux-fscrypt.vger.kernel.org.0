Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDFEFFBD1
	for <lists+linux-fscrypt@lfdr.de>; Sun, 17 Nov 2019 22:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfKQVqR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 17 Nov 2019 16:46:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34068 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfKQVqR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 17 Nov 2019 16:46:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAHLdfpI003596;
        Sun, 17 Nov 2019 21:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=lQsxtj1zILTPO3ytzDWL4aqcpWPnGFH9Mz/GY19HCxE=;
 b=eK956UQqKjf2dIYueXIg/Y2Cb6FPuQxk7c8vJxotCUH+PzNTDZUhNEtS1V7JWWmgbA4t
 W18LnfXuwkt5hePJwfM3grayAZTN6Kqt1gHu+NKAzvAOcURxDZJfixp5louJ5iNUKaur
 Y1BJCNCoAnOozJmSk3c0M/pcgPM6/Hp6oRKrMsqjcG7S8SVk7YFsSU/hf9K93XG357qW
 MBKfY3DWnVFh57J9gZF844R+AaqLkt9kT3GugzcFFhy6H6+VH3WpJ10oPM5iCiPQYHRU
 NJpCAK9h4FWcW4k8zPiyYN0cgPd0ewFhOlrmLL9gJeLXFKup9o5JG65MxsyNfoDF2/eq /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wa9rq4cqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Nov 2019 21:44:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAHLiif8155274;
        Sun, 17 Nov 2019 21:44:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wau8m1qv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Nov 2019 21:44:47 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAHLi9F6010176;
        Sun, 17 Nov 2019 21:44:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 17 Nov 2019 13:44:08 -0800
Date:   Sun, 17 Nov 2019 13:44:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Paul Lawrence <paullawrence@google.com>,
        keyrings@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, David Howells <dhowells@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH] fscrypt: support passing a keyring key to
 FS_IOC_ADD_ENCRYPTION_KEY
Message-ID: <20191117214407.GD6213@magnolia>
References: <20191107001259.115018-1-ebiggers@kernel.org>
 <20191115172832.GA21300@linux.intel.com>
 <20191115192227.GA150987@sol.localdomain>
 <20191115225319.GB29389@linux.intel.com>
 <20191116000139.GB18146@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116000139.GB18146@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9444 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911170206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9444 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911170206
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 15, 2019 at 07:01:39PM -0500, Theodore Y. Ts'o wrote:
> On Sat, Nov 16, 2019 at 12:53:19AM +0200, Jarkko Sakkinen wrote:
> > > I'm working on an xfstest for this:
> > > 
> > > 	https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/commit/?h=fscrypt-provisioning&id=24ab6abb7cf6a80be44b7c72b73f0519ccaa5a97
> > > 
> > > It's not quite ready, though.  I'll post it for review when it is.
> > > 
> > > Someone is also planning to update Android userspace to use this.  So if there
> > > are any issues from that, I'll hear about it.
> > 
> > Cool. Can you combine this patch and matching test (once it is done) to
> > a patch set?
> 
> That's generally not done since the test goes to a different repo
> (xfstests.git) which has a different review process from the kernel
> change.

FWIW I generally send one series per git tree (kernel, *progs, fstests)
one right after another so that they'll all land more or less together
in everybody's inboxes.

--D

> 					- Ted
