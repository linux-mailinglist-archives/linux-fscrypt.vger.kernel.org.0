Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD58502695
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Apr 2022 10:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244196AbiDOIUp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Apr 2022 04:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238683AbiDOIUo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Apr 2022 04:20:44 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2118.outbound.protection.outlook.com [40.107.215.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098FD939ED
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 Apr 2022 01:18:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GI4JlW83/1niN8yhNpMUBUijWnsuqSY4smDsry21LVEeB2jFgrtExzzhPc+23yW/EijOslITXhXBniouaXjU+LbbL7gwNHZyMLpbzx45We8DU0G/ifKhDDJbhjxDv+nfCriGmHVZnaiBfvkynSpJ184TsHT5iYZoZEhCkpYpNoCSLXM23E2K8b6jvXUb1o+Rav11DXYpkCARqp2KpsGcZ7Z3GNlZyq3Wan/CS+gG31WPHoF9lNMFyxMpl4usMSIcbc8WEiqqYHP3/w/p293Y/kVscRAU8rslaCELtrMNDDfCCi/Hq0Go5LiQlNLyJDWJbpiBY/LNLeJ3Kg396X98dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cL88N3i3S5eapgEf+qBg72O+Y8NkiH5plcqW6pNEKaU=;
 b=Ku5xL25Su0c1ixauAj+UiZ1zT27SHAGdtdsgDKu63hnIntoFuhWGT6/Zb0mnLbDUZ5GhCGsCwv5DeuMF78zjYVwTIfJq1Kpyontaip/fFS4Of1dM53peiHZEeXLhql7cljH30fxEkE0ZJNIlNPwKJqogaSMZLx4TqOsTRJogzIX+VLbrzuZo0R6gu5gLkdzXszlNMl84QuoH8tLKgOVrTM8u6rSoJjrMBQJfnsDtcTQ4wMoo4OiVJrHxNj1INfW5tOcRrUErQ1euz9qOI3przKJ5XyhKnhviG7TfGK9HbqVlENwmH8q+JmO6N3UtQ7QzO/weLfKuJ5+1vsrsrNnlMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cL88N3i3S5eapgEf+qBg72O+Y8NkiH5plcqW6pNEKaU=;
 b=NQ8DhWqYOTA3pbR7yiO72lz7840s3RLyjrwrZRV+alP6EE43Z+HooQTxfacns81zGSKZCIlEPUeq6K6fY1/c7Hgl7lvJk2BviYPEoUaImV53gDK4eCP+O4wIte1+Jrw3j5ESQoBqy/fuio5e1zyCPz6mZ/yZ7JPDaqpSYD5EG4A=
Received: from KL1PR0601MB4003.apcprd06.prod.outlook.com (2603:1096:820:26::6)
 by PU1PR06MB2134.apcprd06.prod.outlook.com (2603:1096:803:31::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 08:18:13 +0000
Received: from KL1PR0601MB4003.apcprd06.prod.outlook.com
 ([fe80::f0c7:9081:8b5a:7e7e]) by KL1PR0601MB4003.apcprd06.prod.outlook.com
 ([fe80::f0c7:9081:8b5a:7e7e%8]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 08:18:12 +0000
From:   =?gb2312?B?s6O37+mq?= <changfengnan@vivo.com>
To:     "tytso@mit.edu" <tytso@mit.edu>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "satyat@google.com" <satyat@google.com>
CC:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: why fscrypt_mergeable_bio use logical block number?
Thread-Topic: why fscrypt_mergeable_bio use logical block number?
Thread-Index: AdhQn4rHNxefpxbqR1m92HZ+oE4KkA==
Date:   Fri, 15 Apr 2022 08:18:11 +0000
Message-ID: <KL1PR0601MB4003998B841513BCAA386ADEBBEE9@KL1PR0601MB4003.apcprd06.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ceb4a86-1f58-4269-4318-08da1eb87b79
x-ms-traffictypediagnostic: PU1PR06MB2134:EE_
x-microsoft-antispam-prvs: <PU1PR06MB2134C365C9F27DD1390164ADBBEE9@PU1PR06MB2134.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TmUfmhfg43XXqO27UazImuU2rZ+haOO41yvtiAv0Qf3vMBmWOl1hiSIr5nXqC1D2+wlnDQGW4+EIb697cFhaA8wMqvrTkXUXdnLxyetVtI4LAP1T0QXUuKZU3EYFFUde6shxiW6SJJ7aizb8pWx2XIhIFgsKcjxEN02saP6h0Gdeg3hPIsemzXUczebT9YQexRtNHRdTPIZazuPO2U3H1IuDCHbl14nON3Q6yKvaVp0Z/32ssIJjfj/XrzQ4LOqzOef1LRhPjVaOar/Re4fpkCn9aLFn9G2fnXxhr0nP7VQOrgIADDpMQgw5+flnxCL4hY9Hh7unRw7dViNN7Y6s+TA/DG7eRT7ieDGFQtSnePM21AUiQJ1czlFpuoW8xuV9l0/PoqoEDw3rSWkz2QYgadXi3COGRjuvvHPnFdcZEjdF2BhadszwCI0/ZVTyz18/mvK0NChAGZOw8OWcKhlgXYX+FBNov/84uUOFfNYaOAYBTE7cQid07h8oNdjSNipoaGjwAdQHA9dgk50NSWVy3v3S0E9mRcNDQZvfURu91N+52LTuJR7SwMzbChsP4xxVaHtHrjnpwwI4peVVme9PMe7SefWFhyb6CLEv93MqWVQxCHMPP72Dfn+dL9mP1O0+y+DjOE1o2IbMWPo8NYfVzW26tlRHSKK3EtrAKyhVl/xQpGePLDIIJ2vPvCbBH5Za9Zo8OoFEwpajA7ZX68zmIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB4003.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(55016003)(33656002)(4744005)(66556008)(66476007)(110136005)(186003)(71200400001)(38100700002)(6506007)(26005)(83380400001)(52536014)(8936002)(122000001)(2906002)(8676002)(86362001)(508600001)(66446008)(64756008)(5660300002)(316002)(76116006)(85182001)(4326008)(9686003)(7696005)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?YmgyQmN1UzFrWmJ4WUNsaWpya1JJcmpZYnpLMmFnRElCVkRsYkdWNXZ3N3Nm?=
 =?gb2312?B?NWhzT011TEpPRm9TOWEyQ0ZRZ0JpRE8ra3dDaVZCeSswZklZREtoMk5mbXV4?=
 =?gb2312?B?UlY3em9mU0hpNnlGZjEya0JrbG1BRnk3enlwSG1rZWdZMHBrWmtMYkdWN2Na?=
 =?gb2312?B?c2dObE5lMHZra1paUjNlKzBQU0dkYUd6SHVCNFZqYUE3aXJ6WnpkQ2h6MDhC?=
 =?gb2312?B?NURQS2haclpoUkhlUkhYb1JpWHNoczBjeUNrVHZ1SEd3enBIUzVOTlFmYkhX?=
 =?gb2312?B?MUhQYzNtRjhKcERCdHhZU01vaGxlNWNRbHhQaXArS2E3Y2MzaFUvVkRWdENz?=
 =?gb2312?B?aUpWeTdkS2JaVWhNMyttOFBvNE5wTlNvd2JPVzRNZEVWT2M1TEpqUmQvRExr?=
 =?gb2312?B?NFBNV1Qyb0Qvb2EwNXBqMnlkcXhQdW01QnJQenV0dTRBWjJZQ1NzanUvR2Zu?=
 =?gb2312?B?Q2hGNjdIU1E5SlJDZitaclVITkg2U3JtOVJGUG1ZSHF3VHYzRjJuUitOdkk0?=
 =?gb2312?B?eGx5Sk1jbzZiWWwxSE01RVVqcEhTQTF0MFNUQ3U5T0J6aW1nbjg5ZnJTRi9W?=
 =?gb2312?B?NmU0WUNRcTNwWm9SWVY5SXZFL2RCQ3BqU21IeXRia0JPNktWSUl0VUtGTy9n?=
 =?gb2312?B?MnUwNlpwUGNidjQxWDBCL05SakJXdzBWRXI2ZUx1ZWtJVTU1MVNPcm84MWdZ?=
 =?gb2312?B?YlExVUpTTEhHYUFaWlNjNUtmeWxzaXY3TnJWQlNMaWRlQnRVM056NjJ5Mzc5?=
 =?gb2312?B?aE5kc3k4QlhUMTVLMXE0UURCMGd6M05BNklMRXJlL3ZkODl2YXlGNi9mdEpO?=
 =?gb2312?B?RkJoOWlseERmUWw0VUtjRytZNzNlOWRXV0t4VllubEdnS2dONDc5WE9lL24v?=
 =?gb2312?B?b09rZndoSlNuSHR3V1VvZFVMTStVSEJNS2U4Y1JMQkhSY1lrY3ArZFdXdzBi?=
 =?gb2312?B?cklJSEZ2VHZFVVIwVVM1Q09JL25QcHZtQldtVUt6d1RLV2dDT2w1SUF3UU9D?=
 =?gb2312?B?MERaci9YeG1mTmhDRUZvQnA4QzFqbG5jUmpqZWJLUmFocjRLZVVxOFA2c2Vk?=
 =?gb2312?B?R1VkRTd1Ynd4eE5hNVdlemtZYTZTV0haR2EySTAwemh6UG5QVlpyQjlhUGhR?=
 =?gb2312?B?bmhuekg1SWVUc0dHUzk0WnJpVEx4VzZ2dlhGZU85b2oyRGQwdHYvTW4wOVo5?=
 =?gb2312?B?QXNxbEtQSE05WnZrSVZicGxLWnpHYVk1bFRqR2RZTHBDRERYZUR5Mm4yTXlK?=
 =?gb2312?B?NS9xdTZlWkJQT3pEK3ZzTGk3Q3QxczUzczRpcUNXdGkrN3g1SUtjL2dEUUVO?=
 =?gb2312?B?eHRvVEVOTHF5bloyMDRrUE9SVXpTKzBsSHVmUEYvb29tMTh4alB6QkZXdy9z?=
 =?gb2312?B?eHdTMHNCYUZaTTlZaXR4Q3dJVVFGQXJoT2o2R3pTc3BUcEprbURwU28rSTkz?=
 =?gb2312?B?eWJBMTN4d0pkalMycTVtLzJTVE1nSVd0MFV5L1h0bno0OVlwYUZKVlVXOERK?=
 =?gb2312?B?dEc5eGxtbHZrOWlUMzBYVW9WbFF2dDJKcXRYYzlIalBoWEJFZ0NocDhQOFBU?=
 =?gb2312?B?aW05bHZHWHZrMXJsYTV5eUVLMmdtb0tyUVNKMGg0R3NrUmY5Rmxvcld4OUxz?=
 =?gb2312?B?MWg5bzNZaUFabW55QUtOa1FPdjJNM3RHNnE1NFl0R0xLYUJXb000Y2JIdk83?=
 =?gb2312?B?SXViY1ZpR1RDNGRqR3ZjbVNNNUxhZW4xVnBtdm5qeHUyYXBWU0RXL1VrM1Jm?=
 =?gb2312?B?Y210amxRSURwQi9PS01SU1cwcTVzenZhdlEyN1RnWDV6SWQvT1Y1TTJKNC9l?=
 =?gb2312?B?WC9xaGdLeDZibU1Nb3VoUWhhRmxBaC9FU3hLRkwzb0ZGWlpqMDU0SlFzaHdM?=
 =?gb2312?B?ZUpvVThRWVBSZGk1Z1FJeHVMdlkrbzR6WUNEdmt3SHAvdkJyRGpoUFJnSGlW?=
 =?gb2312?B?UnZTTno0Z0lHRTIwUGI1WkMyN0NhbWJmbE1yK0JZZlk2SldRMzVrNUxnNGxF?=
 =?gb2312?B?NVhrQ0FzOVI1MXZEdGlYblhieUJLZjNwSjJqaGVINEFSak1TRTZ4NkZwdG8z?=
 =?gb2312?B?eGlOWDMvNnFmcDJnc3RmVHk1UFVvb3ovRDRTaFZTKzZ4dkFxV0pyeFVJVzAz?=
 =?gb2312?B?QlZ4Um1aa0JKbnA4WjNoRGFtSmFSa09RTzdVWEtSS3JxMFlhamdmU05yWnFH?=
 =?gb2312?B?RHl0U0ducjJTTkI4RkF6U1pGa1Y5VFAyMnRkTEdZd0NYZEFaeXM5aFVoSVJa?=
 =?gb2312?B?di9BTTRoVi9idnRCb09LNDlBTmxwcFd4UjQxTEZkUmFQanZiQUNYMU1zbHNY?=
 =?gb2312?Q?qPpypqPrW/P7IeHI0v?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB4003.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ceb4a86-1f58-4269-4318-08da1eb87b79
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 08:18:11.8988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y5hvWOINvZjPjgwj1olS2pE68oHjZO+Fz8qHJ8+3KnryPAdq0DuHNhOeswdReepDySqos3+ReHHhN7n8LgK6GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1PR06MB2134
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

SGk6DQoJV2hlbiBJIGRpZyBpbnRvIGEgcHJvYmxlbSwgSSBmb3VuZDogYmlvIG1lcmdlIG1heSBy
ZWR1Y2UgYSBsb3Qgd2hlbiBlbmFibGUgaW5saW5lY3J5cHQsIHRoZSByb290IGNhdXNlIGlzIGZz
Y3J5cHRfbWVyZ2VhYmxlX2JpbyB1c2UgbG9naWNhbCBibG9jayBudW1iZXIgcmF0aGVyIHRoYW4g
cGh5c2ljYWwgYmxvY2sgbnVtYmVyLiBJIGhhZCByZWFkIHRoZSBVRlNIQ0ksIGJ1dCBub3Qgc2Vl
IGFueSBkZXNjcmlwdGlvbiBhYm91dCB3aHkgZGF0YSB1bml0IG51bWJlciBzaG91ZCB1c2UgbG9n
aWNhbCBibG9jayBudW1iZXIuIEkgd2FudCB0byBrbm93IHdoeSwgSXMgdGhlIGFueW9uZSBjYW4g
ZXhwbGFpbiB0aGlzPw0KDQpUaGFua3MuDQpGZW5nbmFuIENoYW5nLg0K
